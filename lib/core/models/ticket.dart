class TicketModel {
  final String id;
  final String matchId; // the _id of the referenced match document
  final String type;
  final double price;
  final String? gate;
  final String? instructions;
  final bool available;
 
  const TicketModel({
    required this.id,
    required this.matchId,
    required this.type,
    required this.price,
    this.gate,
    this.instructions,
    this.available = true,
  });
 
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    // GROQ query uses:  match->{_id}
    // This DEREFERENCES the match so json['match'] = { '_id': '...' }
    // NOT json['match'] = { '_ref': '...' }  ← that would be without ->
    final matchData = json['match'];
    String matchId = '';
    if (matchData is Map) {
      // Dereferenced: match->{_id}  →  { '_id': '...' }
      matchId = matchData['_id'] as String? ?? '';
    }
 
    return TicketModel(
      id: json['_id'],
      matchId: matchId,
      type: json['type'] ?? 'virage',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      gate: json['gate'],
      instructions: json['instructions'],
      available: json['available'] ?? true,
    );
  }
}
 