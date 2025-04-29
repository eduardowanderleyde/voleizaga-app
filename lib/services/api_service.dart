import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart';

class ApiService {
  static const String baseUrl =
      'http://localhost:8000/api'; // Ajustar conforme seu backend

  // Buscar todos os jogadores
  Future<List<Player>> getPlayers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/players'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Player.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar jogadores');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Adicionar novo jogador
  Future<Player> addPlayer(Player player) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/players'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(player.toJson()),
      );

      if (response.statusCode == 201) {
        return Player.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao adicionar jogador');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Atualizar jogador
  Future<Player> updatePlayer(String id, Player player) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/players/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(player.toJson()),
      );

      if (response.statusCode == 200) {
        return Player.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao atualizar jogador');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Deletar jogador
  Future<void> deletePlayer(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/players/$id'));

      if (response.statusCode != 204) {
        throw Exception('Falha ao deletar jogador');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Sortear times
  Future<Map<String, dynamic>> drawTeams(
      List<String> playerIds, int numberOfTeams) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/teams/draw'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'playerIds': playerIds,
          'numberOfTeams': numberOfTeams,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao sortear times');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
