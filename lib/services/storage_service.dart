import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static const String _playersKey = 'players';
  static const String _groupInfoKey = 'group_info';

  static List<Player> _getDefaultPlayers() {
    final uuid = Uuid();
    return [
      Player(
        id: uuid.v4(),
        name: 'João Silva',
        number: 1,
        position: PlayerPosition.setter,
        status: PlayerStatus.active,
        height: 185.0,
        weight: 78.0,
        birthDate: DateTime(1995, 5, 15),
        nationality: 'Brasileiro',
        attack: 6,
        defense: 7,
        reception: 6,
        setting: 9,
        serve: 7,
        communication: 8,
      ),
      Player(
        id: uuid.v4(),
        name: 'Pedro Santos',
        number: 2,
        position: PlayerPosition.outside,
        status: PlayerStatus.active,
        height: 190.0,
        weight: 82.0,
        birthDate: DateTime(1997, 3, 20),
        nationality: 'Brasileiro',
        attack: 9,
        defense: 7,
        reception: 8,
        setting: 5,
        serve: 8,
        speed: 8,
      ),
      Player(
        id: uuid.v4(),
        name: 'Lucas Oliveira',
        number: 3,
        position: PlayerPosition.middle,
        status: PlayerStatus.active,
        height: 195.0,
        weight: 85.0,
        birthDate: DateTime(1996, 8, 10),
        nationality: 'Brasileiro',
        attack: 8,
        defense: 8,
        reception: 5,
        setting: 4,
        serve: 7,
        speed: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Gabriel Costa',
        number: 4,
        position: PlayerPosition.opposite,
        status: PlayerStatus.active,
        height: 188.0,
        weight: 80.0,
        birthDate: DateTime(1998, 12, 5),
        nationality: 'Brasileiro',
        attack: 9,
        defense: 6,
        reception: 6,
        setting: 5,
        serve: 8,
        speed: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Marcos Lima',
        number: 5,
        position: PlayerPosition.libero,
        status: PlayerStatus.active,
        height: 178.0,
        weight: 73.0,
        birthDate: DateTime(1997, 6, 25),
        nationality: 'Brasileiro',
        attack: 4,
        defense: 9,
        reception: 9,
        setting: 6,
        serve: 7,
        speed: 8,
      ),
      Player(
        id: uuid.v4(),
        name: 'Ricardo Souza',
        number: 6,
        position: PlayerPosition.setter,
        status: PlayerStatus.inactive,
        height: 183.0,
        weight: 76.0,
        birthDate: DateTime(1999, 4, 15),
        nationality: 'Brasileiro',
        attack: 5,
        defense: 6,
        reception: 6,
        setting: 8,
        serve: 7,
        communication: 8,
      ),
    ];
  }

  static Future<void> savePlayers(List<Player> players) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final playersJson = players.map((player) => player.toMap()).toList();
      final jsonString = jsonEncode(playersJson);

      if (kDebugMode) {
        print('Salvando jogadores: $jsonString');
      }

      final success = await prefs.setString(_playersKey, jsonString);

      if (!success) {
        throw Exception('Falha ao salvar jogadores no SharedPreferences');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao salvar jogadores: $e');
      }
      throw Exception('Erro ao salvar jogadores: $e');
    }
  }

  static Future<List<Player>> loadPlayers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final playersJson = prefs.getString(_playersKey);

      if (kDebugMode) {
        print('Dados carregados: $playersJson');
      }

      if (playersJson == null || playersJson.isEmpty) {
        if (kDebugMode) {
          print(
              'Nenhum jogador encontrado no armazenamento. Criando jogadores padrão...');
        }
        final defaultPlayers = _getDefaultPlayers();
        await savePlayers(defaultPlayers);
        return defaultPlayers;
      }

      final List<dynamic> decoded = jsonDecode(playersJson);
      final players = decoded.map((json) => Player.fromMap(json)).toList();

      if (kDebugMode) {
        print('Jogadores carregados: ${players.length}');
      }

      return players;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao carregar jogadores: $e');
      }
      throw Exception('Erro ao carregar jogadores: $e');
    }
  }

  static Future<void> saveGroupInfo(Map<String, dynamic> info) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(info);
      final success = await prefs.setString(_groupInfoKey, jsonString);

      if (!success) {
        throw Exception(
            'Falha ao salvar informações do grupo no SharedPreferences');
      }
    } catch (e) {
      throw Exception('Erro ao salvar informações do grupo: $e');
    }
  }

  static Future<Map<String, dynamic>> loadGroupInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final infoJson = prefs.getString(_groupInfoKey);
      if (infoJson == null || infoJson.isEmpty) return {};

      return jsonDecode(infoJson);
    } catch (e) {
      throw Exception('Erro ao carregar informações do grupo: $e');
    }
  }

  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (kDebugMode) {
        print('Todos os dados foram limpos');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao limpar dados: $e');
      }
      throw Exception('Erro ao limpar dados: $e');
    }
  }
}
