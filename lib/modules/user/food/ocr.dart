import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jejom/modules/user/food/menu.dart';
import 'package:jejom/providers/user/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

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
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE0E6FF),
                    Color(0xFFD5E6F3),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 64,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.black26,
                      ),
                    ),
                  ),
                  
                  const Text(
                    "Choose an option",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Camera option
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _openCamera();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "Open Camera",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Gallery option
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickFromGallery();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.photo_library,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "Choose from Gallery",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      'model': 'solar-pro',
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

        // Call the LLM API to format the translated text
        final formatMenuPrompt = '''
      You are given a food menu. Your task is to format the menu in the following format:
      [Food item] - [Price]
      [Food item] - [Price]

      ===

      Here is the unformatted food menu:
      $translatedText
      ''';

        // Call the LLM to format the menu
        await _callLLM(formatMenuPrompt);

        setState(() {
          _ocrText = translatedText;
          _messages.removeWhere((msg) => msg['content'] == 'Translating...');
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
      Generate fully in english.
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
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0E6FF),
                  Color(0xFFD5E6F3),
                ],
              ),
            ),
          ),
          
          // Abstract design elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ),
          
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.1),
              ),
            ),
          ),
      
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                
                // Chat content
                Expanded(
                  child: _showPrompt
                    ? _buildPromptView()
                    : _buildChatView(),
                ),
                
                // Input bar
                if (!_showPrompt)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Camera button
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: const Icon(Icons.photo_camera),
                                  color: Colors.black54,
                                  onPressed: _openModal,
                                ),
                              ),
                              
                              // Text field
                              Expanded(
                                child: TextField(
                                  controller: _textController,
                                  decoration: const InputDecoration(
                                    hintText: "Chat here",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  ),
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ),
                              
                              // Send button
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: const Icon(Icons.send_rounded),
                                  color: Colors.black87,
                                  onPressed: _handleSubmit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPromptView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          
          const Text(
            "Menu & OCR",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 12),
          
          const Text(
            "Translating food has never been so easy, start by taking a picture of the menu.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Camera option
          GestureDetector(
            onTap: _openCamera,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Take a photo",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Gallery option
          GestureDetector(
            onTap: _pickFromGallery,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Choose from gallery",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChatView() {
    return Column(
      children: [
        // Messages
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
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser 
                                  ? Colors.black.withOpacity(0.1) 
                                  : Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isUser
                                    ? Colors.black.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: message['image'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(message['image']!),
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Text(
                                    message['content']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // Action buttons
                if (_messages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GestureDetector(
                      onTap: _handleAllergyCheck,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 18,
                              color: Colors.black87,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Allergy check",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
