// Migrated to the new Firebase AI SDK package
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'lib/firebase_options.dart'; // don't need lib if you're making this file in the actual library folder

Future<void> askGemini() async {
  print('askgemini 1');

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  // final vertexInstance = FirebaseAI.vertexAI(); // add auth - auth: FirebaseAuth.instance
  print('askgemini 2');
  var m = 'gemini-3-pro-preview';
  // var m = 'gemini-2.5-flash';
  // gemini 3 only works on the global server right now. eventually this might change but we'll default to us-central-1. everything else like 2.5 flash works fine on central
  final vertexInstance = m == 'gemini-3-pro-preview' ? FirebaseAI.vertexAI(location: 'global') : FirebaseAI.vertexAI();
  var currentModel = vertexInstance.generativeModel(model: m);
  // FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
  // vertexInstance.generativeModel(model: 'gemini-3-pro-preview');
  print('askgemini 3');
  // var currentImagenModel = _initializeImagenModel(vertexInstance);
  
  final prompt = 'Print your model knowledge cutoff date. Do you know about events in November 2025?';
  print('askgemini 4');
  print(prompt);
  final response = await currentModel.generateContent([Content.text(prompt)]);
  print('askgemini 5');
  // print(response); // Instance of 'GenerateContentResponse'
  // print(response.usageMetadata.toString()); // Instance of 'UsageMetadata'
  print(response.text); // this is the actual response
  // print(response.toString()); // Instance of 'GenerateContentResponse'

  // Print the response text
  print('Response Text: ${response.text}');

  // Print token usage details
  if (response.usageMetadata != null) {
    print('Input Tokens: ${response.usageMetadata!.promptTokenCount}');
    print('Output Tokens: ${response.usageMetadata!.candidatesTokenCount}');
    print('Thinking Tokens: ${response.usageMetadata!.thoughtsTokenCount}');
    print('Total Tokens: ${response.usageMetadata!.totalTokenCount}');
    print('Prompt token details: ${response.usageMetadata!.promptTokensDetails}');
    print('Candidates token details: ${response.usageMetadata!.candidatesTokensDetails}');
  } else {
    print('Token usage metadata is not available.');
  }
  // couldn't get this image prompt to work with 
  print('now testing an image');
  
  final textPart = TextPart('What is this card?');
  Uint8List? imageBytes;
  final String mimeType = 'image/jpeg';

  if (kIsWeb) {
    // Web: Use the asset's relative path
    final imageUrl = 'assets/test_jordan.jpg';
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      imageBytes = response.bodyBytes;
    } else {
      print('Failed to load image from asset: $imageUrl');
      return;
    }
  } else {
    // Non-web: Use rootBundle to load the asset
    final assetPath = 'assets/test_jordan.jpg';
    try {
      imageBytes = await rootBundle.load(assetPath).then((byteData) => byteData.buffer.asUint8List());
    } catch (e) {
      print('Failed to load image from asset: $assetPath');
      return;
    }
  }

  if (imageBytes == null) {
    print('No image bytes available.');
    return;
  }

  // Create the image part (InlineDataPart)
  final imagePart = InlineDataPart(
    mimeType,
    imageBytes,
  );

  // Construct the "parts" of the prompt from the text and image
  final List<Part> contents = [
    textPart,
    imagePart,
  ];

  // Send the request
  final response2 = await currentModel.generateContent(
    [Content.multi(contents)],
  );
  print('Image-based prompt completed.');

  print('Response Text: ${response2.text}');

  if (response2.usageMetadata != null) {
    print('Input Tokens: ${response2.usageMetadata!.promptTokenCount}');
    print('Output Tokens: ${response2.usageMetadata!.candidatesTokenCount}');
    print('Thinking Tokens: ${response2.usageMetadata!.thoughtsTokenCount}');
    print('Total Tokens: ${response2.usageMetadata!.totalTokenCount}');
    print('Prompt token details: ${response2.usageMetadata!.promptTokensDetails}');
    print('Candidates token details: ${response2.usageMetadata!.candidatesTokensDetails}');
  } else {
    print('Token usage metadata is not available.');
  }
}

void main() async {
  print('hi! starting testing_firebase_ai');
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print(dotenv.env);
  print('about to askGemini');
  await askGemini();
}