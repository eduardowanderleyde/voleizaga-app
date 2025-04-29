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
        name: 'Carlinha',
        number: 1,
        position: PlayerPosition.setter,
        status: PlayerStatus.active,
        height: 165.0,
        weight: 60.0,
        nationality: 'Brasileiro',
        attack: 7,
        defense: 7,
        reception: 7,
        setting: 8,
        serve: 7,
        block: 6,
        communication: 8,
      ),
      Player(
        id: uuid.v4(),
        name: 'Hugo',
        number: 2,
        position: PlayerPosition.outside,
        status: PlayerStatus.active,
        height: 180.0,
        weight: 75.0,
        nationality: 'Brasileiro',
        attack: 8,
        defense: 7,
        reception: 7,
        setting: 6,
        serve: 7,
        block: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Shama',
        number: 3,
        position: PlayerPosition.middle,
        status: PlayerStatus.active,
        height: 185.0,
        weight: 80.0,
        nationality: 'Brasileiro',
        attack: 7,
        defense: 7,
        reception: 6,
        setting: 6,
        serve: 7,
        block: 8,
        speed: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Dan',
        number: 4,
        position: PlayerPosition.outside,
        status: PlayerStatus.active,
        height: 175.0,
        weight: 70.0,
        nationality: 'Brasileiro',
        attack: 8,
        defense: 7,
        reception: 7,
        setting: 6,
        serve: 7,
        block: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Art',
        number: 5,
        position: PlayerPosition.middle,
        status: PlayerStatus.active,
        height: 182.0,
        weight: 78.0,
        nationality: 'Brasileiro',
        attack: 7,
        defense: 7,
        reception: 6,
        setting: 6,
        serve: 7,
        block: 8,
        speed: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Gus',
        number: 6,
        position: PlayerPosition.setter,
        status: PlayerStatus.active,
        height: 178.0,
        weight: 73.0,
        nationality: 'Brasileiro',
        attack: 6,
        defense: 7,
        reception: 7,
        setting: 8,
        serve: 7,
        block: 6,
        communication: 8,
      ),
      Player(
        id: uuid.v4(),
        name: 'Bruno',
        number: 7,
        position: PlayerPosition.outside,
        status: PlayerStatus.active,
        height: 180.0,
        weight: 75.0,
        nationality: 'Brasileiro',
        attack: 8,
        defense: 7,
        reception: 7,
        setting: 6,
        serve: 7,
        block: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Izi',
        number: 8,
        position: PlayerPosition.middle,
        status: PlayerStatus.active,
        height: 183.0,
        weight: 78.0,
        nationality: 'Brasileiro',
        attack: 7,
        defense: 7,
        reception: 6,
        setting: 6,
        serve: 7,
        block: 8,
        speed: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'João',
        number: 9,
        position: PlayerPosition.outside,
        status: PlayerStatus.active,
        height: 175.0,
        weight: 70.0,
        nationality: 'Brasileiro',
        attack: 8,
        defense: 7,
        reception: 7,
        setting: 6,
        serve: 7,
        block: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Sara',
        number: 10,
        position: PlayerPosition.setter,
        status: PlayerStatus.active,
        height: 168.0,
        weight: 62.0,
        nationality: 'Brasileiro',
        attack: 6,
        defense: 7,
        reception: 7,
        setting: 8,
        serve: 7,
        block: 6,
        communication: 8,
      ),
      Player(
        id: uuid.v4(),
        name: 'Vivi',
        number: 11,
        position: PlayerPosition.middle,
        status: PlayerStatus.active,
        height: 175.0,
        weight: 65.0,
        nationality: 'Brasileiro',
        attack: 7,
        defense: 7,
        reception: 6,
        setting: 6,
        serve: 7,
        block: 8,
        speed: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Wanda',
        number: 12,
        position: PlayerPosition.outside,
        status: PlayerStatus.active,
        height: 170.0,
        weight: 63.0,
        nationality: 'Brasileiro',
        attack: 8,
        defense: 7,
        reception: 7,
        setting: 6,
        serve: 7,
        block: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Zinho',
        number: 13,
        position: PlayerPosition.middle,
        status: PlayerStatus.active,
        height: 185.0,
        weight: 80.0,
        nationality: 'Brasileiro',
        attack: 7,
        defense: 7,
        reception: 6,
        setting: 6,
        serve: 7,
        block: 8,
        speed: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Nath BR',
        number: 14,
        position: PlayerPosition.setter,
        status: PlayerStatus.active,
        height: 165.0,
        weight: 60.0,
        nationality: 'Brasileiro',
        attack: 6,
        defense: 7,
        reception: 7,
        setting: 8,
        serve: 7,
        block: 6,
        communication: 8,
      ),
      Player(
        id: uuid.v4(),
        name: 'Lucca',
        number: 15,
        position: PlayerPosition.outside,
        status: PlayerStatus.active,
        height: 178.0,
        weight: 73.0,
        nationality: 'Brasileiro',
        attack: 8,
        defense: 7,
        reception: 7,
        setting: 6,
        serve: 7,
        block: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Ricardo',
        number: 16,
        position: PlayerPosition.middle,
        status: PlayerStatus.active,
        height: 183.0,
        weight: 78.0,
        nationality: 'Brasileiro',
        attack: 7,
        defense: 7,
        reception: 6,
        setting: 6,
        serve: 7,
        block: 8,
        speed: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Saulo',
        number: 17,
        position: PlayerPosition.outside,
        status: PlayerStatus.active,
        height: 180.0,
        weight: 75.0,
        nationality: 'Brasileiro',
        attack: 8,
        defense: 7,
        reception: 7,
        setting: 6,
        serve: 7,
        block: 7,
      ),
      Player(
        id: uuid.v4(),
        name: 'Bruna',
        number: 18,
        position: PlayerPosition.setter,
        status: PlayerStatus.active,
        height: 168.0,
        weight: 62.0,
        nationality: 'Brasileiro',
        attack: 6,
        defense: 7,
        reception: 7,
        setting: 8,
        serve: 7,
        block: 6,
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
