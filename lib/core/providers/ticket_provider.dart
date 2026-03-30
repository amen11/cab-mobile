import 'package:cab_app/core/models/ticket.dart';
import 'package:flutter/foundation.dart';
import '../services/sanity_service.dart';
 
class TicketProvider extends ChangeNotifier {
  List<TicketModel> _tickets = [];
  bool _loading = false;
  String? _error;
 
  List<TicketModel> get tickets => _tickets;
  bool get loading => _loading;
  String? get error => _error;
 
  List<TicketModel> ticketsForMatch(String matchId) =>
      _tickets.where((t) => t.matchId == matchId).toList();
 
  Future<void> fetchTickets() async {
    _loading = true;
    notifyListeners();
    try {
      final results = await SanityService.query(
        '''*[_type == "ticket" && available == true] {
          _id, type, price, gate, instructions, available,
          match->{_id}
        }''',
      );
      _tickets = results.map((r) => TicketModel.fromJson(r)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
 