import 'package:cab_app/core/models/match.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sanity_service.dart';
 
// ─────────────────────────────────────────────────────────────────────────────
//  MatchProvider
// ─────────────────────────────────────────────────────────────────────────────
class MatchProvider extends ChangeNotifier {
  List<MatchModel> _upcoming = [];
  List<MatchModel> _past     = [];
  bool    _loading = false;
  String? _error;
 
  List<MatchModel> get upcoming => _upcoming;
  List<MatchModel> get past     => _past;
  MatchModel? get nextMatch     => _upcoming.isNotEmpty ? _upcoming.first : null;
  MatchModel? get lastMatch     => _past.isNotEmpty    ? _past.last      : null;
  bool        get loading       => _loading;
  String?     get error         => _error;
 
  MatchModel? findById(String id) {
    try { return [..._upcoming, ..._past].firstWhere((m) => m.id == id); }
    catch (_) { return null; }
  }
 
  Future<void> fetchMatches() async {
    _loading = true;
    _error   = null;
    notifyListeners();
    try {
      final results = await SanityService.query(
        r'''*[_type == "match"] | order(date asc) {
          _id, opponent, date, stadium, isHome,
          status, scoreCAB, scoreOpponent, competition,
          opponentLogo{ asset }
        }''',
      );
      final all = results
          .map((r) => MatchModel.fromJson(r as Map<String, dynamic>))
          .toList();
      _upcoming = all.where((m) => m.date.isAfter(DateTime.now())).toList();
      _past     = all.where((m) => !m.date.isAfter(DateTime.now())).toList();
    } catch (e) {
      _error = e.toString();
      debugPrint('MatchProvider error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
 