import 'package:flutter/material.dart';
import '../controller/github_controller.dart';
import '../models/vegetal_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GitHubController _controller = GitHubController();
  List<Vegetal> _vegetales = [];

  @override
  void initState() {
    super.initState();
    _loadVegetales();
  }

  Future<void> _loadVegetales() async {
    final vegetales = await _controller.syncVegetales();
    setState(() {
      _vegetales = vegetales;
    });
  }

  void _addVegetal() {
    final vegetal = Vegetal(
        codigo: _vegetales.length + 1,
        descripcion: 'Nuevo Vegetal',
        precio: 0.0
    );
    setState(() {
      _vegetales.add(vegetal);
    });
    _controller.updateVegetales(_vegetales);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vegetales')),
      body: ListView.builder(
        itemCount: _vegetales.length,
        itemBuilder: (context, index) {
          final vegetal = _vegetales[index];
          return ListTile(
            title: Text(vegetal.descripcion),
            subtitle: Text('\$${vegetal.precio}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVegetal,
        child: Icon(Icons.add),
      ),
    );
  }
}