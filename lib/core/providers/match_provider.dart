import 'package:cab_app/core/models/match.dart';
import 'package:flutter/foundation.dart';
import '../services/sanity_service.dart';
 
class MatchProvider extends ChangeNotifier {
  List<MatchModel> _upcoming = [];
  List<MatchModel> _past = [];
  MatchModel? _nextMatch;
  MatchModel? _lastMatch;
  bool _loading = false;
  String? _error;
 
  List<MatchModel> get upcoming => _upcoming;
  List<MatchModel> get past => _past;
  MatchModel? get nextMatch => _nextMatch;
  MatchModel? get lastMatch => _lastMatch;
  bool get loading => _loading;
  String? get error => _error;
 
  Future<void> fetchMatches() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final now = DateTime.now().toIso8601String();
      final results = await SanityService.query(
        '''*[_type == "match"] | order(date asc) {
          _id, opponent, date, stadium, isHome,
          status, scoreCAB, scoreOpponent, competition,
          opponentLogo{asset->{_ref}}
        }''',
      );
      final all = results.map((r) => MatchModel.fromJson(r)).toList();
      _upcoming = all.where((m) => m.date.isAfter(DateTime.now())).toList();
      _past = all.where((m) => m.date.isBefore(DateTime.now())).toList();
      _nextMatch = _upcoming.isNotEmpty ? _upcoming.first : null;
      _lastMatch = _past.isNotEmpty ? _past.last : null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}