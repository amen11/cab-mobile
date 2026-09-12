class MatchModel {
  final String id;
  final String opponent;
  final DateTime date;
  final String? stadium;
  final bool isHome;
  final String status;
  final int? scoreCAB;
  final int? scoreOpponent;
  final String? competition;
  final String? opponentLogoRef;
 
  const MatchModel({
    required this.id,
    required this.opponent,
    required this.date,
    this.stadium,
    this.isHome = true,
    required this.status,
    this.scoreCAB,
    this.scoreOpponent,
    this.competition,
    this.opponentLogoRef,
  });
 
  factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
        id: json['_id'],
        opponent: json['opponent'] ?? 'Unknown',
        date: DateTime.parse(json['date']),
        stadium: json['stadium'],
        isHome: json['isHome'] ?? true,
        status: json['status'] ?? 'upcoming',
        scoreCAB: json['scoreCAB'],
        scoreOpponent: json['scoreOpponent'],
        competition: json['competition'],
        // opponentLogo asset _ref — NOT dereferenced in GROQ so still has _ref
        opponentLogoRef: json['opponentLogo']?['asset']?['_ref'],
      );
}
 