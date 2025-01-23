import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vegetal_model.dart';

class LocalStorageService {
  static const String _key = 'vegetales';

  Future<void> saveVegetales(List<Vegetal> vegetales) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = vegetales.map((v) => v.toJson()).toList();
    await prefs.setString(_key, json.encode(jsonList));
  }

  Future<List<Vegetal>> loadVegetales() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString != null) {
      final jsonList = json.decode(jsonString);
      return (jsonList as List).map((e) => Vegetal.fromJson(e)).toList();
    }
    return [];
  }
}