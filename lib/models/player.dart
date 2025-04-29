import 'package:flutter/foundation.dart';

enum PlayerPosition {
  setter, // Levantador
  outside, // Ponteiro
  opposite, // Oposto
  middle, // Central
  libero // Líbero
}

enum PlayerStatus { active, inactive, injured, suspended }

class Player {
  final String id;
  final String name;
  final int number;
  final PlayerPosition position;
  final PlayerStatus status;
  final double height;
  final double weight;
  final String? photoUrl;
  final DateTime? birthDate;
  final String nationality;
  final bool isPresent;

  // Habilidades (0-5)
  final int attack; // Ataque
  final int defense; // Defesa
  final int setting; // Levantamento
  final int reception; // Recepção
  final int serve; // Saque
  final int block; // Bloqueio
  final int? speed; // Velocidade (opcional)
  final int? communication; // Comunicação (opcional)

  // Contato
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
    this.birthDate,
    required this.nationality,
    this.isPresent = true,
    required this.attack,
    required this.defense,
    required this.setting,
    required this.reception,
    required this.serve,
    required this.block,
    this.speed,
    this.communication,
    this.phone,
    this.email,
  });

  // Método estático para converter posição em string amigável
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

  // Método estático para converter status em string amigável
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

  // Getter para calcular a média das habilidades
  double get averageSkills {
    int sum = attack + defense + setting + reception + serve + block;
    int count = 6;

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

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      position: PlayerPosition.values.firstWhere(
        (p) => p.toString().split('.').last == json['position'],
      ),
      status: PlayerStatus.values.firstWhere(
        (s) => s.toString().split('.').last == json['status'],
      ),
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      photoUrl: json['photo_url'],
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : null,
      nationality: json['nationality'],
      attack: json['attack'],
      defense: json['defense'],
      setting: json['setting'],
      reception: json['reception'],
      serve: json['serve'],
      block: json['block'] ?? 5,
      speed: json['speed'],
      communication: json['communication'],
      phone: json['phone'],
      email: json['email'],
      isPresent: json['is_present'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'position': position.toString().split('.').last,
      'status': status.toString().split('.').last,
      'height': height,
      'weight': weight,
      'photo_url': photoUrl,
      'birth_date': birthDate?.toIso8601String(),
      'nationality': nationality,
      'attack': attack,
      'defense': defense,
      'setting': setting,
      'reception': reception,
      'serve': serve,
      'block': block,
      'speed': speed,
      'communication': communication,
      'phone': phone,
      'email': email,
      'is_present': isPresent,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'position': position.index,
      'status': status.index,
      'height': height,
      'weight': weight,
      'photoUrl': photoUrl,
      'birthDate': birthDate?.toIso8601String(),
      'nationality': nationality,
      'isPresent': isPresent,
      'attack': attack,
      'defense': defense,
      'setting': setting,
      'reception': reception,
      'serve': serve,
      'block': block,
      'speed': speed,
      'communication': communication,
      'phone': phone,
      'email': email,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as String,
      name: map['name'] as String,
      number: map['number'] as int,
      position: PlayerPosition.values[map['position'] as int],
      status: PlayerStatus.values[map['status'] as int],
      height: (map['height'] as num).toDouble(),
      weight: (map['weight'] as num).toDouble(),
      photoUrl: map['photoUrl'] as String?,
      birthDate: map['birthDate'] != null
          ? DateTime.parse(map['birthDate'] as String)
          : null,
      nationality: map['nationality'] as String,
      isPresent: map['isPresent'] as bool? ?? true,
      attack: map['attack'] as int,
      defense: map['defense'] as int,
      setting: map['setting'] as int,
      reception: map['reception'] as int,
      serve: map['serve'] as int,
      block: map['block'] as int? ?? 5,
      speed: map['speed'] as int?,
      communication: map['communication'] as int?,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
    );
  }

  Player copyWith({
    String? id,
    String? name,
    int? number,
    PlayerPosition? position,
    PlayerStatus? status,
    double? height,
    double? weight,
    String? photoUrl,
    DateTime? birthDate,
    String? nationality,
    bool? isPresent,
    int? attack,
    int? defense,
    int? setting,
    int? reception,
    int? serve,
    int? block,
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
      block: block ?? this.block,
      speed: speed ?? this.speed,
      communication: communication ?? this.communication,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'Player(id: $id, name: $name, number: $number, position: $position, status: $status, height: $height, weight: $weight, photoUrl: $photoUrl, birthDate: $birthDate, nationality: $nationality, attack: $attack, defense: $defense, reception: $reception, setting: $setting, serve: $serve, speed: $speed, communication: $communication, phone: $phone, email: $email, isPresent: $isPresent)';
  }
}
