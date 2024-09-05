import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jejom/modules/food/menu.dart';
import 'package:jejom/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MenuOCRPage extends StatefulWidget {
  const MenuOCRPage({super.key});

  @override
  State<MenuOCRPage> createState() => _MenuOCRPageState();
}

class _MenuOCRPageState extends State<MenuOCRPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedImage;
  String? _ocrText;
  String? _llmResponse;
  bool _isLoading = false;
  bool _showPrompt = true;

  List<Map<String, String?>> _messages = [];
  final int _historyThreshold = 5;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _openModal();
    // });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _showPrompt = false;
    });
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _isLoading = true;
        _messages.add({
          'role': 'user',
          'content': null,
          'image': _selectedImage!.path,
        });
      });
      await _callOCR();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _showPrompt = false;
    });
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _isLoading = true;
        _messages.add({
          'role': 'user',
          'content': null,
          'image': _selectedImage!.path,
        });
      });
      await _callOCR();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openModal() async {
    setState(() {
      _showPrompt = true;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text('Open Camera',
                  style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _openCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('Choose from Gallery',
                  style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
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
      _messages.add({'role': 'system', 'content': 'Loading...'});
    });

    final url = Uri.parse('https://api.upstage.ai/v1/document-ai/ocr');
    final request = http.MultipartRequest('POST', url);
    String apiKey = dotenv.env['UPSTAGE_API_KEY'] ?? '';
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.files.add(
        await http.MultipartFile.fromPath('document', _selectedImage!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = utf8.decode(await response.stream.toBytes());
      final responseBody = json.decode(responseData);

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('text')) {
        final extractedText = responseBody['text'];
        setState(() {
          _ocrText = extractedText;
          _messages.removeWhere((msg) => msg['content'] == 'Loading...');
        });
        _scrollToBottom();

        await _callTranslation(extractedText);
      } else {
        setState(() {
          _messages.removeWhere((msg) => msg['content'] == 'Loading...');
          _messages.add(
              {'role': 'system', 'content': 'Error: Incorrect OCR response.'});
        });
        _scrollToBottom();
      }
    } else {
      print('OCR failed: ${response.statusCode}');
      setState(() {
        _messages.removeWhere((msg) => msg['content'] == 'Loading...');
        _messages
            .add({'role': 'system', 'content': 'Error occurred during OCR.'});
      });
      _scrollToBottom();
    }
  }

  Future<void> _callLLM(String userPrompt) async {
    setState(() {
      _messages.add({'role': 'system', 'content': 'Loading...'});
    });

    final url = Uri.parse('https://api.upstage.ai/v1/solar/chat/completions');
    String apiKey = dotenv.env['UPSTAGE_API_KEY'] ?? '';
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    List<Map<String, String?>> recentMessages =
        _messages.length > _historyThreshold
            ? _messages.sublist(_messages.length - _historyThreshold)
            : _messages;

    String formattedMessages = recentMessages.map((msg) {
      final role = msg['role'] == 'user' ? 'User' : 'Assistant';
      return '$role: ${msg['content']}';
    }).join('\n');

    final systemPrompt = '''
    You are a helpful assistant.
    Menu: ${_ocrText ?? "No menu available"}
    Recent messages:
    $formattedMessages
    ''';

    final body = json.encode({
      'model': 'solar-1-mini-chat',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      'stream': false,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = utf8.decode(response.bodyBytes);
      final responseBody = json.decode(responseData);

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('choices')) {
        final llmMessage = responseBody['choices'][0]['message']['content'];
        setState(() {
          _messages.removeWhere((msg) => msg['content'] == 'Loading...');
          _messages.add({'role': 'system', 'content': llmMessage});
        });
        _scrollToBottom();
      } else {
        setState(() {
          _messages.removeWhere((msg) => msg['content'] == 'Loading...');
          _messages.add({
            'role': 'system',
            'content': 'Error: Unexpected response structure.'
          });
        });
        _scrollToBottom();
      }
    } else {
      print('LLM error: ${response.statusCode}');
      setState(() {
        _messages.removeWhere((msg) => msg['content'] == 'Loading...');
        _messages.add({'role': 'system', 'content': 'Error occurred.'});
      });
      _scrollToBottom();
    }
  }

  Future<void> _callTranslation(String textToTranslate) async {
    setState(() {
      _messages.add({'role': 'system', 'content': 'Translating...'});
    });

    final url = Uri.parse('https://api.upstage.ai/v1/solar/chat/completions');
    String apiKey = dotenv.env['UPSTAGE_API_KEY'] ?? '';
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'model': 'solar-1-mini-translate-koen',
      'messages': [
        {'role': 'user', 'content': textToTranslate}
      ],
      'stream': false,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = utf8.decode(response.bodyBytes);
      final responseBody = json.decode(responseData);

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('choices')) {
        final translatedText = responseBody['choices'][0]['message']['content'];
        setState(() {
          _ocrText = translatedText;
          _messages.removeWhere((msg) => msg['content'] == 'Translating...');
          _messages.add({'role': 'system', 'content': translatedText});
        });
        _scrollToBottom();
      } else {
        setState(() {
          _messages.removeWhere((msg) => msg['content'] == 'Translating...');
          _messages.add(
              {'role': 'system', 'content': 'Error: Unexpected response.'});
        });
        _scrollToBottom();
      }
    } else {
      print('Translation failed: ${response.statusCode}');
      setState(() {
        _messages.removeWhere((msg) => msg['content'] == 'Translating...');
        _messages.add({
          'role': 'system',
          'content': 'Error occurred during translation.'
        });
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _handleSubmit() {
    if (_textController.text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': _textController.text});
      _isLoading = true;
    });

    _callLLM(_textController.text);

    _textController.clear();

    _scrollToBottom();
  }

  void _handleOrder() {
    if (_ocrText != null) {
      _callLLM('''
      Generate 3 sentences to teach foreigners how to order food from the menu. Each sentence should be in the following format: Korean (Romanized) - English. 
      For example, 아이스 아메리카노 한 잔 주세요 (Aiseu Amerikano han jan juseyo) - One iced Americano, please.
      ''');
    } else {
      setState(() {
        _messages
            .add({'role': 'system', 'content': 'Error: No menu available.'});
      });
      _scrollToBottom();
    }
  }

  void _handleAllergyCheck() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      if (user.allergies.isEmpty || user.dietary.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealPreferences(onPreferencesUpdated: () {
              _continueAllergyCheck();
            }),
          ),
        );
      } else {
        _continueAllergyCheck();
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealPreferences(onPreferencesUpdated: () {
            _continueAllergyCheck();
          }),
        ),
      );
    }
  }

  void _continueAllergyCheck() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      String allergyList = user.allergies.join(', ');
      String dietaryPreference = user.dietary;

      String prompt = '''
      Here is the list of allergies: $allergyList and the dietary preference: $dietaryPreference. 
      Your task is to identify which food items in the menu are not suitable for the user's dietary preference.
      After that, you need to identify which food items in the menu may contain the allergens listed. 
      The menu might contain the ingredients of each dish, you need to think step by step to identify the ingredients in each dish that may contain the allergens listed.
      Respond in the following format: 
      Food item that suits the dietary preference (the name of the dietary preference):
      [Food item] - Reason
      Food item with allergens (the name of the allergens): 
      [Food item] - Reason 
      Generate fully in english
      ''';

      _callLLM(prompt);
    } else {
      setState(() {
        _messages.add(
            {'role': 'system', 'content': 'Error: Unable to fetch user data.'});
      });
    }
    _scrollToBottom();
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
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _messages.length,
                                itemBuilder: (context, index) {
                                  final message = _messages[index];
                                  final isUser = message['role'] == 'user';
                                  return Align(
                                    alignment: isUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isUser
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primaryContainer
                                            : Theme.of(context)
                                                .colorScheme
                                                .surface,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: message['image'] != null
                                          ? Image.file(
                                              File(message['image']!),
                                              width:
                                                  200, // Adjust size as needed
                                              fit: BoxFit.cover,
                                            )
                                          : Text(
                                              message['content']!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                    ),
                                  );
                                },
                              ),
                              if (_messages.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ActionChip(
                                        label: const Text('Order Food'),
                                        onPressed: _handleOrder,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer),
                                      ),
                                      const SizedBox(width: 16),
                                      ActionChip(
                                        label: const Text('Allergy check'),
                                        onPressed: _handleAllergyCheck,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
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
                                  hintText: "Chat here",
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.photo_camera),
                                    color: Colors.white,
                                    onPressed: _openModal,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.send),
                                    color: Colors.white,
                                    onPressed: _handleSubmit,
                                  ),
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.background,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_showPrompt)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Text("Menu & OCR",
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 16),
                    Text(
                        "Translating food has never been so easy, start by taking a picture of the menu.",
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _openCamera,
                          icon: const Icon(Icons.photo_camera),
                          label: const Text('Camera'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Gallery'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
