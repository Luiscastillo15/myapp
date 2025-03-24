import 'package:flutter/material.dart';
import 'package:myapp/Servicios/apiServicios.dart';
import 'package:myapp/Modelos/todos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(25, 211, 218, 1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const AplicacionproductScreen(),
    );
  }
}

class AplicacionproductScreen extends StatefulWidget {
  const AplicacionproductScreen({super.key});

  @override
  State<AplicacionproductScreen> createState() =>
      _AplicacionproductScreenState();
}

class _AplicacionproductScreenState extends State<AplicacionproductScreen> {
  final serviciosApi apiServicios = serviciosApi();
  late Future<List<Todos>> futureTodos;

  void _addproduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String titulo = '';
        return AlertDialog(
          title: const Text('Agregar Producto'),
          content: TextField(
            onChanged: (value) {
              titulo = value;
            },
            decoration: const InputDecoration(
              hintText: 'Titulo',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () async {
                if (titulo.isNotEmpty) {
                  Todos nuevotodo = Todos(
                    userId: 1,
                    id: 0,
                    title: titulo,
                    completed: false,
                  );
                  await apiServicios.crearTodo(nuevotodo);
                  setState(() {
                    futureTodos = apiServicios.fetchTodo();
                  });
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    futureTodos = apiServicios.fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicacion de Productos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Todos>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Todos> todos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todos todo = todos[index];
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (value) {
                        setState(() {
                          todo.completed = value!;
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        apiServicios.eliminarTodo(todo.id);
                        setState(() {
                          todos.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addproduct,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
