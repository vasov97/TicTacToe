import 'package:tic_tac_toe/resources/game_manager.dart';

class Player {
  final String nickname;
  final String socketID;
  final int points;
  final String playerType;
 
  Player({
    required this.nickname,
    required this.socketID,
    required this.points,
    required this.playerType,
    
  });

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'socketID': socketID,
      'points': points,
      'playerType': playerType,
     
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      nickname: map['nickname'] ?? '',
      socketID: map['socketID'] ?? '',
      points: map['points']?.toInt() ?? 0,
      playerType: map['playerType'] ?? '',
     
    );
  }

  Player copyWith({
    String? nickname,
    String? socketID,
    int? points,
    String? playerType,
    int? gamesWon,
  }) {
    return Player(
      nickname: nickname ?? this.nickname,
      socketID: socketID ?? this.socketID,
      points: points ?? this.points,
      playerType: playerType ?? this.playerType,
      
    );
  }
}