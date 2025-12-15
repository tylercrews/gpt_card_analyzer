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
  var test_prompt = """Take the image of the sports card I have uploaded, and see if you can figure out the player name, sport, and card brand.
    Then look that card up on www.tcdb.com and see if you can find an image match for the card.
    Extract the name of the card and look that up on www.130point.com to see if there are any prices for it.

    Finally, I want you to give me the results as a spreadsheet row (in text that I can copy and paste into Excel/Sheets) as
    Player name, sport, card brand, successfully found on tcdb (y/n), the URL link to the tcdb match, official card name, successfully found on 130point (y/n), the URL link to the 130point match, 130point price, estimated price from other sources, source of price estimate (name), source of price estimate (URL), price from estimate or 130point > \$5""";


  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  // final vertexInstance = FirebaseAI.vertexAI(); // add auth - auth: FirebaseAuth.instance

  // initialize the three different models
  var pro3 = 'gemini-3-pro-preview';
  var flash25 = 'gemini-2.5-flash';
  var flashlite25 = 'gemini-2.5-flash-lite';
  var pro3model = FirebaseAI.vertexAI(location: 'global').generativeModel(model: pro3);
  var flash25model = FirebaseAI.vertexAI().generativeModel(model: flash25);
  var flashlite25model = FirebaseAI.vertexAI().generativeModel(model: flashlite25); 
  
  final textPart = TextPart(test_prompt);
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

  print('testing model 1 - ${pro3}');

  // Send the request
  final response1 = await pro3model.generateContent(
    [Content.multi(contents)],
  );

  print('Response Text: ${response1.text}');

  if (response1.usageMetadata != null) {
    print('Input Tokens: ${response1.usageMetadata!.promptTokenCount}');
    print('Output Tokens: ${response1.usageMetadata!.candidatesTokenCount}');
    print('Thinking Tokens: ${response1.usageMetadata!.thoughtsTokenCount}');
    print('Total Tokens: ${response1.usageMetadata!.totalTokenCount}');
    print('Prompt token details: ${response1.usageMetadata!.promptTokensDetails}');
    print('Candidates token details: ${response1.usageMetadata!.candidatesTokensDetails}');
  } else {
    print('Token usage metadata is not available.');
  }

  
  print('testing model 2 - ${flash25}');

  // Send the request
  final response2 = await flash25model.generateContent(
    [Content.multi(contents)],
  );

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

  
  print('testing model 3 - ${flashlite25}');

  // Send the request
  final response3 = await flashlite25model.generateContent(
    [Content.multi(contents)],
  );

  print('Response Text: ${response2.text}');

  if (response3.usageMetadata != null) {
    print('Input Tokens: ${response3.usageMetadata!.promptTokenCount}');
    print('Output Tokens: ${response3.usageMetadata!.thoughtsTokenCount}');
    print('Total Tokens: ${response3.usageMetadata!.totalTokenCount}');
    print('Prompt token details: ${response3.usageMetadata!.promptTokensDetails}');
    print('Candidates token details: ${response3.usageMetadata!.candidatesTokensDetails}');
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