// Migrated to the new Firebase AI SDK package
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';

import 'lib/firebase_options.dart'; // don't need lib if you're making this file in the actual library folder


// ...




Future<void> askGemini() async {

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  // 1. No API Key needed in the code! It uses your Firebase login automatically.
  // Use the new FirebaseAI singleton to obtain a generative model instance.
  final model = FirebaseAI.instance.generativeModel(
    model: 'gemini-1.5-flash',
  );

  // 2. Direct call from the app (Securely)
  final response = await model.generateContent([
    Content.text('Why is the sky blue?'),
  ]);

  print(response.text);
}