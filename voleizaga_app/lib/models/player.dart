import 'package:flutter/foundation.dart';

enum PlayerPosition { setter, outside, opposite, middle, libero }

enum PlayerStatus { active, inactive, injured, suspended }

class Player {
  final String id;
  final String name;
  final int number;
  final PlayerPosition position;
  final PlayerStatus status;
  final double height; // Alterado de int para double
  final double weight; // Alterado de int para double
  final String? photoUrl;
  final DateTime birthDate;
  final String nationality;
  final bool isPresent;
  final int attack;
  final int defense;
  final int setting;
  final int reception;
  final int serve;
  final int? speed;
  final int? communication;
  final String? phone;
  final String? email;

  Player({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.status,
    required this.height,
    required this.weight,
    this.photoUrl,
    required this.birthDate,
    required this.nationality,
    this.isPresent = true,
    required this.attack,
    required this.defense,
    required this.setting,
    required this.reception,
    required this.serve,
    this.speed,
    this.communication,
    this.phone,
    this.email,
  });

  double get averageSkills {
    var sum = attack + defense + setting + reception + serve;
    var count = 5;

    if (speed != null) {
      sum += speed!;
      count++;
    }
    if (communication != null) {
      sum += communication!;
      count++;
    }

    return sum / count;
  }

  Player copyWith({
    String? id,
    String? name,
    int? number,
    PlayerPosition? position,
    PlayerStatus? status,
    double? height, // Alterado de int para double
    double? weight, // Alterado de int para double
    String? photoUrl,
    DateTime? birthDate,
    String? nationality,
    bool? isPresent,
    int? attack,
    int? defense,
    int? setting,
    int? reception,
    int? serve,
    int? speed,
    int? communication,
    String? phone,
    String? email,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      position: position ?? this.position,
      status: status ?? this.status,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      photoUrl: photoUrl ?? this.photoUrl,
      birthDate: birthDate ?? this.birthDate,
      nationality: nationality ?? this.nationality,
      isPresent: isPresent ?? this.isPresent,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      setting: setting ?? this.setting,
      reception: reception ?? this.reception,
      serve: serve ?? this.serve,
      speed: speed ?? this.speed,
      communication: communication ?? this.communication,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  static String positionToString(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.setter:
        return 'Levantador';
      case PlayerPosition.outside:
        return 'Ponteiro';
      case PlayerPosition.opposite:
        return 'Oposto';
      case PlayerPosition.middle:
        return 'Central';
      case PlayerPosition.libero:
        return 'Líbero';
    }
  }

  static String statusToString(PlayerStatus status) {
    switch (status) {
      case PlayerStatus.active:
        return 'Ativo';
      case PlayerStatus.inactive:
        return 'Inativo';
      case PlayerStatus.injured:
        return 'Lesionado';
      case PlayerStatus.suspended:
        return 'Suspenso';
    }
  }
}
