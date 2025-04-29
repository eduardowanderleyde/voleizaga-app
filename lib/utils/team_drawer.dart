import '../models/player.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';

class TeamResult {
  final List<List<Player>> teams;
  final String? error;

  TeamResult({required this.teams, this.error});
}

class TeamDrawer {
  static TeamResult drawTeams(List<Player> players, {int numberOfTeams = 2}) {
    // Validar número de times
    if (numberOfTeams < 2 || numberOfTeams > 4) {
      return TeamResult(
        teams: [],
        error: 'O número de times deve ser 2, 3 ou 4',
      );
    }

    final presentPlayers = players.where((p) => p.isPresent).toList();

    if (kDebugMode) {
      print('Jogadores presentes: ${presentPlayers.length}');
    }

    // Calcular mínimo de jogadores necessários (6 por time)
    final minPlayers = numberOfTeams * 6;
    if (presentPlayers.length < minPlayers) {
      return TeamResult(
        teams: [],
        error:
            'São necessários pelo menos $minPlayers jogadores presentes para formar $numberOfTeams times',
      );
    }

    // Separar jogadores por posição
    final setters = presentPlayers
        .where((p) => p.position == PlayerPosition.setter)
        .toList()
      ..shuffle();
    final outsides = presentPlayers
        .where((p) => p.position == PlayerPosition.outside)
        .toList()
      ..shuffle();
    final middles = presentPlayers
        .where((p) => p.position == PlayerPosition.middle)
        .toList()
      ..shuffle();

    if (kDebugMode) {
      print('Levantadores: ${setters.length}');
      print('Ponteiros: ${outsides.length}');
      print('Centrais: ${middles.length}');
    }

    // Verificar se há jogadores suficientes em cada posição (2 por time)
    final minPerPosition = numberOfTeams * 2;
    if (setters.length < minPerPosition ||
        outsides.length < minPerPosition ||
        middles.length < minPerPosition) {
      return TeamResult(
        teams: [],
        error:
            'São necessários pelo menos:\n- $minPerPosition levantadores\n- $minPerPosition ponteiros\n- $minPerPosition centrais',
      );
    }

    // Criar combinações de times
    List<List<List<Player>>> teamCombinations = [];

    // Gerar várias combinações diferentes
    for (var i = 0; i < 5; i++) {
      var teams = List.generate(numberOfTeams, (index) => <Player>[]);
      var teamScores = List.generate(numberOfTeams, (index) => 0.0);

      // Distribuir levantadores (2 por time)
      for (var j = 0; j < numberOfTeams; j++) {
        teams[j].addAll(setters.sublist(j * 2, (j + 1) * 2));
        teamScores[j] +=
            teams[j].map(_getPositionScore).reduce((a, b) => a + b);
      }

      // Distribuir ponteiros (2 por time)
      for (var j = 0; j < numberOfTeams; j++) {
        teams[j].addAll(outsides.sublist(j * 2, (j + 1) * 2));
        teamScores[j] +=
            teams[j].map(_getPositionScore).reduce((a, b) => a + b);
      }

      // Distribuir centrais (2 por time)
      for (var j = 0; j < numberOfTeams; j++) {
        teams[j].addAll(middles.sublist(j * 2, (j + 1) * 2));
        teamScores[j] +=
            teams[j].map(_getPositionScore).reduce((a, b) => a + b);
      }

      teamCombinations.add(teams);
    }

    // Ordenar combinações pela diferença de pontuação entre times
    teamCombinations.sort((a, b) {
      var scoresA = a
          .map((team) => team.map(_getPositionScore).reduce((a, b) => a + b))
          .toList();
      var scoresB = b
          .map((team) => team.map(_getPositionScore).reduce((a, b) => a + b))
          .toList();

      var diffA = scoresA.reduce(max) - scoresA.reduce(min);
      var diffB = scoresB.reduce(max) - scoresB.reduce(min);

      return diffA.compareTo(diffB);
    });

    if (teamCombinations.isEmpty) {
      return TeamResult(
        teams: [],
        error: 'Não foi possível gerar times equilibrados',
      );
    }

    return TeamResult(teams: teamCombinations[0], error: null);
  }

  // Função auxiliar para calcular pontuação específica por posição
  static double _getPositionScore(Player player) {
    switch (player.position) {
      case PlayerPosition.setter:
        return (player.setting * 3 +
                player.defense +
                (player.communication ?? 5)) /
            5.0;
      case PlayerPosition.outside:
        return (player.attack * 2 + player.reception * 2 + player.serve) / 5.0;
      case PlayerPosition.opposite:
        return (player.attack * 3 + player.serve * 2) / 5.0;
      case PlayerPosition.middle:
        return (player.attack * 2 + player.defense * 2 + (player.speed ?? 5)) /
            5.0;
      case PlayerPosition.libero:
        return (player.defense * 3 + player.reception * 2) / 5.0;
    }
  }
}
