import 'dart:convert';
import 'package:http/http.dart' as http;
 
class SanityService {
  static const _projectId = 'u3dbxd38';   // ← from sanity.io dashboard
  static const _dataset   = 'production';
  static const _apiVersion = '2024-01-01';
 
  static String get _baseUrl =>
      'https://$_projectId.api.sanity.io/v$_apiVersion/data/query/$_dataset';
 
  // Write token for creating orders (keep secret in production – use a backend)
  static const _writeToken = 'skTprWL49EuqB7edlWjBX3qdwGaMM3mFFFGD9s1cB0sacvNFrpVVdpuZfOp8S463V4i572wrZj1AamsJkkCaV8qcK3ir0ZFqT1OVNruqSatKxtdhnCFBG0ov4cHJSzIdsGhchDnQHV0ZyAMris7T9qTpp6ZJOlHQjqkcf7DNJIF4aCw9Q4W0'; // ← from sanity.io > API > Tokens
 
  static Future<List<dynamic>> query(String groq) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {'query': groq},
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data['result'] as List<dynamic>;
    }
    throw Exception('Sanity query failed: ${res.statusCode}');
  }
 
  static Future<Map<String, dynamic>> mutate(List<Map> mutations) async {
    final uri = Uri.parse(
        'https://$_projectId.api.sanity.io/v$_apiVersion/data/mutate/$_dataset');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_writeToken',
      },
      body: json.encode({'mutations': mutations}),
    );
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Sanity mutation failed: ${res.statusCode}');
  }
 
  // Helper: build Sanity image URL
  static String imageUrl(String ref, {int width = 800}) {
    // ref format: image-<id>-<dimensions>-<format>
    final parts = ref.replaceFirst('image-', '').split('-');
    final id = parts[0];
    final format = parts.last;
    return 'https://cdn.sanity.io/images/$_projectId/$_dataset/$id.$format?w=$width&auto=format';
  }
}