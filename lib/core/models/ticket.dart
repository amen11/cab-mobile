class TicketModel {
  final String id;
  final String matchId;
  final String type; // virage | pelouse | tribune
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
 
  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        id: json['_id'],
        matchId: json['match']?['_ref'] ?? '',
        type: json['type'],
        price: (json['price'] as num).toDouble(),
        gate: json['gate'],
        instructions: json['instructions'],
        available: json['available'] ?? true,
      );
}