import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OCRService {
  static Future<String> recognizeText(File image) async {
    try {
      var uri = Uri.parse("http://72.56.237.11:5000/ocr");

      var request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      var response = await request.send().timeout(
        const Duration(seconds: 60),
      );

      if (response.statusCode != 200) {
        return "Ошибка сервера: ${response.statusCode}";
      }

      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if (jsonData['error'] != null) {
        return "Ошибка: ${jsonData['error']}";
      }

      return jsonData['text'] ?? "Нет текста";

    } catch (e) {
      return "Ошибка подключения: $e";
    }
  }
}