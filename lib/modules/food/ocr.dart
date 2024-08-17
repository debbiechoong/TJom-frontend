import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'dart:io';

class MenuOCRPage extends StatefulWidget {
  const MenuOCRPage({Key? key}) : super(key: key);

  @override
  _MenuOCRPageState createState() => _MenuOCRPageState();
}

class _MenuOCRPageState extends State<MenuOCRPage> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;
  String? _ocrText;
  String? _llmResponse;
  Offset _floatingButtonPos = Offset(300, 50);
  bool _showNotes = false;
  bool _isLoading = false;

  List<Map<String, String>> _messages = [];

  final Map<String, bool> _checkedSentences = {
    '일 인분 주세요. (Il-een-boon Ju-se-yo) - Please give me one serving.': false,
    '김치 주세요 (Igeo juseyo) - Please give me Kimchi': false,
    '계산해주세요 (Gyesanhaejuseyo) - Please calculate (the bill)': false,
  };

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Open Camera'),
              onTap: () async {
                Navigator.pop(context);
                final pickedImage =
                    await ImagePicker().getImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  setState(() {
                    _selectedImage = File(pickedImage.path);
                    _isLoading = true;
                  });
                  await _callOCR();
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedImage =
                    await ImagePicker().getImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _selectedImage = File(pickedImage.path);
                    _isLoading = true;
                  });
                  await _callOCR();
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _callOCR() async {
    if (_selectedImage == null) return;

    setState(() {
      _messages.add({'role': 'system', 'content': 'loading...'});
    });

    final url = Uri.parse('https://api.upstage.ai/v1/document-ai/ocr');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer API_KEY';
    request.files.add(
        await http.MultipartFile.fromPath('document', _selectedImage!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final responseBody = json.decode(responseData.body);

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('text')) {
        final extractedText = responseBody['text'];
        setState(() {
          _ocrText = extractedText;
          _messages.removeWhere((msg) => msg['content'] == 'loading...');
          _messages.add({'role': 'user', 'content': extractedText});
        });
        await _callLLM(extractedText);
      } else {
        // TODO: Error handling
        setState(() {
          _messages.removeWhere((msg) => msg['content'] == 'loading...');
          _messages
              .add({'role': 'system', 'content': 'Error: Incorrect response.'});
        });
      }
    } else {
      print('OCR failed: ${response.statusCode}');
      setState(() {
        _messages.removeWhere((msg) => msg['content'] == 'loading...');
        _messages.add({'role': 'system', 'content': 'Error occurred.'});
      });
    }
  }

  Future<void> _callLLM(String text) async {
    setState(() {
      _messages.add({'role': 'system', 'content': 'loading...'});
    });

    final url = Uri.parse('https://api.upstage.ai/v1/solar/chat/completions');
    final headers = {
      'Authorization': 'Bearer API_KEY',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'model': 'solar-1-mini-chat',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': text},
      ],
      'stream': false,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('choices')) {
        final llmMessage = responseData['choices'][0]['message']['content'];
        setState(() {
          _messages.removeWhere((msg) => msg['content'] == 'loading...');
          _messages.add({'role': 'system', 'content': llmMessage});
        });
      } else {
        print('Unexpected response structure');
        setState(() {
          _messages.removeWhere((msg) => msg['content'] == 'loading...');
          _messages.add({
            'role': 'system',
            'content': 'Error: Unexpected response structure'
          });
        });
      }
    } else {
      print('LLM error: ${response.statusCode}');
      setState(() {
        _messages.removeWhere((msg) => msg['content'] == 'loading...');
        _messages.add({'role': 'system', 'content': 'Error occurred.'});
      });
    }
  }

  void _handleCheckboxToggle(String sentence) {
    setState(() {
      _checkedSentences[sentence] = !_checkedSentences[sentence]!;
    });
    _showBalloonAnimation();
  }

  void _handleSubmit() {
    if (_textController.text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': _textController.text});
      _isLoading = true;
    });

    _callLLM(_textController.text);

    _textController.clear();
  }

  void _toggleKoreanSentences() {
    setState(() {
      _showNotes = !_showNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUser = message['role'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFA6E84E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message['content']!,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText: 'Talk to Jejom',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFAF120),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFAF120),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        color: Colors.white,
                        onPressed: _handleSubmit,
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFFFAF120),
                          child: Icon(Icons.photo_camera, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: _floatingButtonPos.dx,
              top: _floatingButtonPos.dy,
              child: Draggable(
                feedback: FloatingActionButton(
                  onPressed: _toggleKoreanSentences,
                  child: Icon(Icons.chat),
                  backgroundColor: Color(0xFFFAF120),
                ),
                childWhenDragging: Container(),
                onDraggableCanceled: (Velocity velocity, Offset offset) {
                  setState(() {
                    _floatingButtonPos = offset;
                  });
                },
                child: FloatingActionButton(
                  onPressed: _toggleKoreanSentences,
                  child: Icon(Icons.chat),
                  backgroundColor: Color(0xFFFAF120),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomSheet: _showNotes ? _buildKoreanSentencesOverlay() : null,
    );
  }

  Widget _buildKoreanSentencesOverlay() {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _checkedSentences.keys.map((sentence) {
                return ListTile(
                  title: Text(sentence, style: TextStyle(color: Colors.white)),
                  trailing: GestureDetector(
                    onTap: () => _handleCheckboxToggle(sentence),
                    child: _checkedSentences[sentence]!
                        ? Icon(Icons.check, color: Colors.green)
                        : Checkbox(
                            value: _checkedSentences[sentence],
                            onChanged: (bool? value) {
                              _handleCheckboxToggle(sentence);
                            },
                          ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _showBalloonAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Lottie.asset(
          'assets/balloon_fireworks.json',
          width: 200,
          height: 200,
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(composition.duration, () {
              Navigator.of(context).pop();
            });
          },
        ),
      ),
    ).then((_) {
      _toggleKoreanSentences();
    });
  }
}
