import 'package:flutter/foundation.dart';

class Rating {
  final String id;
  final String playerId;
  final String raterId;
  final DateTime date;
  final int attack;
  final int defense;
  final int setting;
  final int reception;
  final int serve;
  final int block;
  final String? comment;

  Rating({
    required this.id,
    required this.playerId,
    required this.raterId,
    required this.date,
    required this.attack,
    required this.defense,
    required this.setting,
    required this.reception,
    required this.serve,
    required this.block,
    this.comment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      playerId: json['player_id'],
      raterId: json['rater_id'],
      date: DateTime.parse(json['date']),
      attack: json['attack'],
      defense: json['defense'],
      setting: json['setting'],
      reception: json['reception'],
      serve: json['serve'],
      block: json['block'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_id': playerId,
      'rater_id': raterId,
      'date': date.toIso8601String(),
      'attack': attack,
      'defense': defense,
      'setting': setting,
      'reception': reception,
      'serve': serve,
      'block': block,
      'comment': comment,
    };
  }

  Rating copyWith({
    String? id,
    String? playerId,
    String? raterId,
    DateTime? date,
    int? attack,
    int? defense,
    int? setting,
    int? reception,
    int? serve,
    int? block,
    String? comment,
  }) {
    return Rating(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      raterId: raterId ?? this.raterId,
      date: date ?? this.date,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      setting: setting ?? this.setting,
      reception: reception ?? this.reception,
      serve: serve ?? this.serve,
      block: block ?? this.block,
      comment: comment ?? this.comment,
    );
  }
}
