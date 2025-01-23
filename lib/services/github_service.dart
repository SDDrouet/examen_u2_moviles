import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/vegetal_model.dart';

class GitHubService {
  final String _baseUrl = 'https://api.github.com';
  final String _owner = 'sddrouet';
  final String _repo = 'https://github.com/SDDrouet/examen_u2_moviles.git';
  final String _path = 'vegetales.json';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String> _getAccessToken() async {
    return await _storage.read(key: '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') ?? '';
  }

  Future<List<Vegetal>> fetchVegetales() async {
    final token = await _getAccessToken();
    final response = await http.get(
        Uri.parse('$_baseUrl/repos/$_owner/$_repo/contents/$_path'),
        headers: {
          'Authorization': 'token $token',
          'Accept': 'application/vnd.github.v3+json'
        }
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final content = base64Decode(decoded['content']);
      final jsonList = json.decode(utf8.decode(content));
      return (jsonList as List).map((e) => Vegetal.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener vegetales');
    }
  }

  Future<void> updateVegetales(List<Vegetal> vegetales) async {
    final token = await _getAccessToken();
    final content = base64Encode(utf8.encode(json.encode(vegetales)));

    // Obtener el SHA actual del archivo
    final fileResponse = await http.get(
        Uri.parse('$_baseUrl/repos/$_owner/$_repo/contents/$_path'),
        headers: {
          'Authorization': 'token $token',
          'Accept': 'application/vnd.github.v3+json'
        }
    );

    final sha = json.decode(fileResponse.body)['sha'];

    final updateResponse = await http.put(
        Uri.parse('$_baseUrl/repos/$_owner/$_repo/contents/$_path'),
        headers: {
          'Authorization': 'token $token',
          'Accept': 'application/vnd.github.v3+json'
        },
        body: json.encode({
          'message': 'Actualización de vegetales',
          'content': content,
          'sha': sha
        })
    );

    if (updateResponse.statusCode != 200) {
      throw Exception('Error al actualizar vegetales');
    }
  }
}