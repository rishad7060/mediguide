import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  static const String apiKey = "AIzaSyAo66O9AwM8HpwAdWp7ITnvYXuedB46Ovg";
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  Future<String?> generateResponse(String prompt) async {
    final content = [Content.text("${prompt}medicine")];
    final response = await model.generateContent(content);
    print(response.text);
    return response.text;
  }
}
