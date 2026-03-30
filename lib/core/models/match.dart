class MatchModel {
  final String id;
  final String opponent;
  final DateTime date;
  final String? stadium;
  final bool isHome;
  final String status; // upcoming | live | finished
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
        opponent: json['opponent'],
        date: DateTime.parse(json['date']),
        stadium: json['stadium'],
        isHome: json['isHome'] ?? true,
        status: json['status'] ?? 'upcoming',
        scoreCAB: json['scoreCAB'],
        scoreOpponent: json['scoreOpponent'],
        competition: json['competition'],
        opponentLogoRef: json['opponentLogo']?['asset']?['_ref'],
      );
}