import 'package:cab_app/core/models/news.dart';
import 'package:flutter/foundation.dart';
import '../services/sanity_service.dart';
 
class NewsProvider extends ChangeNotifier {
  List<NewsModel> _articles = [];
  bool _loading = false;
  String? _error;
 
  List<NewsModel> get articles => _articles;
  List<NewsModel> get latest => _articles.take(3).toList();
  bool get loading => _loading;
  String? get error => _error;
 
  Future<void> fetchNews() async {
    _loading = true;
    notifyListeners();
    try {
      final results = await SanityService.query(
        '''*[_type == "news"] | order(publishedAt desc) {
          _id, title, summary, publishedAt,
          image{asset->{_ref}},
          content
        }''',
      );
      _articles = results.map((r) => NewsModel.fromJson(r)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
 