import 'package:cab_app/core/models/news.dart';
import 'package:cab_app/core/services/sanity_service.dart';
import 'package:flutter/material.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> _articles = [];
  bool    _loading = false;
  String? _error;
 
  List<NewsModel> get articles => _articles;
  List<NewsModel> get latest   => _articles.take(3).toList();
  bool        get loading      => _loading;
  String?     get error        => _error;
 
  Future<void> fetchNews() async {
    _loading = true;
    _error   = null;
    notifyListeners();
    try {
      final results = await SanityService.query(
        r'''*[_type == "news"] | order(publishedAt desc) {
          _id,
          title,
          summary,
          publishedAt,
          image{ asset },
          content[]{
            _type,
            _key,
            style,
            children[]{
              _type,
              _key,
              text,
              marks
            },
            markDefs
          }
        }''',
      );
      _articles = results
          .map((r) => NewsModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e.toString();
      debugPrint('NewsProvider error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}