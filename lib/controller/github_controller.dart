import '../models/vegetal_model.dart';
import '../services/github_service.dart';
import '../services/local_storage_service.dart';

class GitHubController {
  final GitHubService _githubService = GitHubService();
  final LocalStorageService _localService = LocalStorageService();

  Future<List<Vegetal>> syncVegetales() async {
    try {
      // Obtener de GitHub
      final githubVegetales = await _githubService.fetchVegetales();

      // Guardar localmente
      await _localService.saveVegetales(githubVegetales);

      return githubVegetales;
    } catch (e) {
      // Cargar desde almacenamiento local si falla GitHub
      return await _localService.loadVegetales();
    }
  }

  Future<void> updateVegetales(List<Vegetal> vegetales) async {
    // Guardar local y GitHub
    await _localService.saveVegetales(vegetales);
    await _githubService.updateVegetales(vegetales);
  }
}