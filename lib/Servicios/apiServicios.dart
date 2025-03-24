import 'package:http/http.dart' as http;
import 'package:myapp/Modelos/todos.dart';
import 'dart:convert';

class serviciosApi {
  final String url = 'https://jsonplaceholder.typicode.com';

  Future<List<Todos>> fetchTodo() async {
    final response = await http.get(Uri.parse('$url/todos'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((e) => Todos.fromMap(e)).toList();
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future<Todos> crearTodo(Todos todos) async {
    final response = await http.post(
      Uri.parse('$url/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todos.toJson()),
    );
    if (response.statusCode == 201) {
      return Todos.fromJson(response.body);
    } else {
      throw Exception('Error al crear el todo');
    }
  }

  Future<void> actualizarTodo(Todos todos) async {
    final response = await http.put(
      Uri.parse('$url/todos/${todos.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todos.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el todo');
    }
  }

  Future<void> eliminarTodo(int id) async {
    final response = await http.delete(Uri.parse('$url/todos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el todo');
    }
  }
}
