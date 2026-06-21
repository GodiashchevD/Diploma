import 'dart:convert';
import 'package:http/http.dart' as http;

class TestService {
  static Future<List<dynamic>> generateTest(String text) async {
    final uri = Uri.parse("http://72.56.237.11:5000/generate-test");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": text}),
      );

      if (response.statusCode != 200) {
        throw Exception("Ошибка сервера: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);

      // Проверяем поле test (как приходит от сервера)
      if (data["test"] != null && data["test"] is List) {
        return List<dynamic>.from(data["test"]);
      }
      
      // Запасные варианты
      if (data["questions"] != null && data["questions"] is List) {
        return List<dynamic>.from(data["questions"]);
      }
      
      if (data["raw"] != null) {
        String rawText = data["raw"].toString();
        
        try {
          final parsed = jsonDecode(rawText);
          if (parsed is List) {
            return parsed;
          }
        } catch (e) {
          final jsonStart = rawText.indexOf('[');
          final jsonEnd = rawText.lastIndexOf(']');
          
          if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
            final jsonString = rawText.substring(jsonStart, jsonEnd + 1);
            try {
              final parsed = jsonDecode(jsonString);
              if (parsed is List) {
                return parsed;
              }
            } catch (e) {}
          }
        }
      }

      throw Exception("Неверный формат данных от сервера");
      
    } catch (e) {
      throw Exception("Ошибка при генерации теста: $e");
    }
  }
}