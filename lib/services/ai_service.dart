import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // ضع مفتاح OpenAI هنا للتجربة فقط.
  // للنشر الحقيقي لا تضع المفتاح داخل التطبيق، استخدم Firebase Cloud Functions.
  static const String apiKey = 'PUT_YOUR_OPENAI_API_KEY_HERE';

  static Future<String> askLifeScript({
    required String userMessage,
    required String memory,
  }) async {
    if (apiKey.startsWith('PUT_')) {
      return 'Demo mode: ضع OpenAI API Key داخل lib/services/ai_service.dart حتى يعمل الذكاء الاصطناعي الحقيقي.';
    }

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'system',
            'content': '''
You are LifeScript AI.
You are not a general assistant.
You are a personal life coach and living book.
User memory:
$memory

Rules:
- Never give generic answers.
- Give personalized analysis, plan, or direction.
- Keep answers clear and practical.
'''
          },
          {'role': 'user', 'content': userMessage},
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return 'AI error: ${response.statusCode} ${response.body}';
    }

    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'] ?? 'No response';
  }
}
