import 'package:shared_preferences/shared_preferences.dart'; // Importa la biblioteca de SharedPreferences

class SearchCounter {
  static const _key = 'search_count'; // Clave utilizada para almacenar el contador en SharedPreferences

  // Método para obtener el contador de búsquedas almacenado en SharedPreferences
  Future<int> getSearchCount() async {
    final prefs = await SharedPreferences.getInstance(); // Obtiene una instancia de SharedPreferences
    return prefs.getInt(_key) ?? 0; // Retorna el contador de búsquedas o 0 si no hay valor almacenado
  }

  // Método para incrementar el contador de búsquedas y almacenarlo en SharedPreferences
  Future<void> incrementSearchCount() async {
    final prefs = await SharedPreferences.getInstance(); // Obtiene una instancia de SharedPreferences
    int currentCount = prefs.getInt(_key) ?? 0; // Obtiene el valor actual del contador
    await prefs.setInt(_key, currentCount + 1); // Incrementa el contador y guarda el nuevo valor
  }

  // Método para restablecer el contador de búsquedas eliminando su valor de SharedPreferences
  Future<void> resetSearchCount() async {
    final prefs = await SharedPreferences.getInstance(); // Obtiene una instancia de SharedPreferences
    await prefs.remove(_key); // Elimina el valor del contador de búsquedas
  }
}
