// import 'dart:convert';
// import 'package:http/http.dart' as http;
 
// class SanityService {
//   static const _projectId = 'u3dbxd38';   // ← from sanity.io dashboard
//   static const _dataset   = 'production';
//   static const _apiVersion = '2024-01-01';
 
//   static String get _baseUrl =>
//       'https://$_projectId.api.sanity.io/v$_apiVersion/data/query/$_dataset';
 
//   // Write token for creating orders (keep secret in production – use a backend)
//   static const _writeToken = 'skTprWL49EuqB7edlWjBX3qdwGaMM3mFFFGD9s1cB0sacvNFrpVVdpuZfOp8S463V4i572wrZj1AamsJkkCaV8qcK3ir0ZFqT1OVNruqSatKxtdhnCFBG0ov4cHJSzIdsGhchDnQHV0ZyAMris7T9qTpp6ZJOlHQjqkcf7DNJIF4aCw9Q4W0'; // ← from sanity.io > API > Tokens
 
//   static Future<List<dynamic>> query(String groq) async {
//     final uri = Uri.parse(_baseUrl).replace(
//       queryParameters: {'query': groq},
//     );
//     final res = await http.get(uri);
//     if (res.statusCode == 200) {
//       final data = json.decode(res.body);
//       return data['result'] as List<dynamic>;
//     }
//     throw Exception('Sanity query failed: ${res.statusCode}');
//   }
 
//   static Future<Map<String, dynamic>> mutate(List<Map> mutations) async {
//     final uri = Uri.parse(
//         'https://$_projectId.api.sanity.io/v$_apiVersion/data/mutate/$_dataset');
//     final res = await http.post(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $_writeToken',
//       },
//       body: json.encode({'mutations': mutations}),
//     );
//     if (res.statusCode == 200) return json.decode(res.body);
//     throw Exception('Sanity mutation failed: ${res.statusCode}');
//   }
 
//   // Helper: build Sanity image URL
//   static String imageUrl(String ref, {int width = 800}) {
//     // ref format: image-<id>-<dimensions>-<format>
//     final parts = ref.replaceFirst('image-', '').split('-');
//     final id = parts[0];
//     final format = parts.last;
//     return 'https://cdn.sanity.io/images/$_projectId/$_dataset/$id.$format?w=$width&auto=format';
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SanityService {
  // 🔐 CONFIG
  static const _projectId  = 'u3dbxd38'; // ← keep your real one
  static const _dataset    = 'production';
  static const _writeToken = 'skTprWL49EuqB7edlWjBX3qdwGaMM3mFFFGD9s1cB0sacvNFrpVVdpuZfOp8S463V4i572wrZj1AamsJkkCaV8qcK3ir0ZFqT1OVNruqSatKxtdhnCFBG0ov4cHJSzIdsGhchDnQHV0ZyAMris7T9qTpp6ZJOlHQjqkcf7DNJIF4aCw9Q4W0';

  // ── Query (READ) ───────────────────────────────────────────────────────────
  static Future<List<dynamic>> query(String groq) async {
    // Clean query (remove new lines/spaces)
    final compact = groq
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .join(' ');

    // ✅ Correct way (NO manual encoding)
    final uri = Uri.https(
      '$_projectId.api.sanity.io',
      '/v2024-01-01/data/query/$_dataset',
      {
        'query': compact,
      },
    );

    debugPrint('🔍 Sanity URL: $uri');

    final res = await http.get(uri).timeout(const Duration(seconds: 15));

    debugPrint('📡 Status: ${res.statusCode}');
    debugPrint('📡 Body: ${res.body}');

    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      return data['result'] as List<dynamic>? ?? [];
    }

    throw Exception('Sanity query failed: ${res.statusCode}\n${res.body}');
  }

  // ── Mutate (WRITE) ─────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> mutate(List<Map> mutations) async {
    final uri = Uri.https(
      '$_projectId.api.sanity.io',
      '/v2024-01-01/data/mutate/$_dataset',
    );

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_writeToken',
      },
      body: json.encode({'mutations': mutations}),
    ).timeout(const Duration(seconds: 15));

    if (res.statusCode == 200 || res.statusCode == 201) {
      return json.decode(res.body) as Map<String, dynamic>;
    }

    throw Exception('Sanity mutation failed: ${res.statusCode}\n${res.body}');
  }

  // ── Image URL ──────────────────────────────────────────────────────────────
  static String imageUrl(String ref, {int width = 800}) {
    if (ref.isEmpty) return '';

    final withoutPrefix = ref.replaceFirst('image-', '');
    final lastDash = withoutPrefix.lastIndexOf('-');

    if (lastDash == -1) {
      return 'https://cdn.sanity.io/images/$_projectId/$_dataset/$withoutPrefix?w=$width&auto=format';
    }

    final filename =
        '${withoutPrefix.substring(0, lastDash)}'
        '.'
        '${withoutPrefix.substring(lastDash + 1)}';

    return 'https://cdn.sanity.io/images/$_projectId/$_dataset/$filename?w=$width&auto=format';
  }
}