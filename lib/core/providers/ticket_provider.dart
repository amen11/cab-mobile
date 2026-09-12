import 'package:cab_app/core/models/ticket.dart';
import 'package:cab_app/core/services/sanity_service.dart';
import 'package:flutter/material.dart';

class TicketProvider extends ChangeNotifier {
  List<TicketModel> _tickets = [];
  bool    _loading = false;
  String? _error;
 
  List<TicketModel> get tickets => _tickets;
  bool          get loading     => _loading;
  String?       get error       => _error;
 
  List<TicketModel> ticketsForMatch(String matchId) =>
      _tickets.where((t) => t.matchId == matchId).toList();
 
  Future<void> fetchTickets() async {
    _loading = true;
    _error   = null;
    notifyListeners();
    try {
      // match->{ _id }  dereferences the reference → model reads json['match']['_id']
      final results = await SanityService.query(
        r'''*[_type == "ticket" && available == true] {
          _id, type, price, gate, instructions, available,
          match->{ _id }
        }''',
      );
      _tickets = results
          .map((r) => TicketModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e.toString();
      debugPrint('TicketProvider error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}