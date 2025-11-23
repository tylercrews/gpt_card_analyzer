import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. Import

void main() async {
  // 2. Ensure Flutter bindings initialized, then load the file
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _responseText;
  bool _loading = true;
  bool _hasKey = false;

  @override
  void initState() {
    super.initState();
    _initAndQuery();
  }

  Future<void> _initAndQuery() async {
    final apiKey = dotenv.env['API_KEY_GEMINI'] ?? '';
    setState(() {
      _hasKey = apiKey.isNotEmpty;
    });

    if (apiKey.isEmpty) {
      setState(() {
        _responseText = 'API key not found';
        _loading = false;
      });
      return;
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-3-pro-preview',
        apiKey: apiKey,
      );
      final prompt = [Content.text('Print your model knowledge cutoff date. Do you know about events in November 2025?')];
      print(prompt);
      final response = await model.generateContent(prompt);
      print(response.usageMetadata.toString());

      setState(() {
        _responseText = response.text ?? response.toString();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('GPT Card Analyzer - Test')),
        body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('API key present: \\${_hasKey ? 'yes' : 'no'}'),
                      const SizedBox(height: 12),
                      Text(_responseText ?? 'No response'),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}