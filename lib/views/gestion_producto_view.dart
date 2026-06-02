import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../database/connection.dart'; // Importación de la base de datos de Stocky

class GestionProductoView extends StatefulWidget {
  final int userId; // ID del usuario que posee el producto
  final int? productoId; // Si es nulo = Crear, si tiene número = Editar

  const GestionProductoView({super.key, required this.userId, this.productoId});

  @override
  State<GestionProductoView> createState() => _GestionProductoViewState();
}

class _GestionProductoViewState extends State<GestionProductoView> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar el texto de la interfaz web
  final _nombreController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.productoId != null) {
      _cargarDatosProducto();
    }
  }

  /// Carga la información del producto desde la base de datos para el modo edición.
  Future<void> _cargarDatosProducto() async {
    final producto = await AppDatabase.instance.obtenerProductoPorId(widget.productoId!);
    if (producto != null) {
      setState(() {
        _nombreController.text = producto.nombre;
        _categoriaController.text = producto.categoria;
        _precioController.text = producto.precio.toString();
        _stockController.text = producto.stock.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productoId == null ? 'Añadir Producto a Stocky' : 'Editar Producto en Stocky'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500), // Tamaño ideal para que se vea como tarjeta en la Web
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                  validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoriaController,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    final p = double.tryParse(v);
                    if (p == null || p <= 0) return 'Precio inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Stock Inicial'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    final s = int.tryParse(v);
                    if (s == null || s < 0) return 'Stock inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _guardar,
                  child: Text(widget.productoId == null ? 'Guardar Producto' : 'Actualizar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Procesa el guardado o actualización del producto.
  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      // Parseo de datos validados
      final nombre = _nombreController.text.trim();
      final categoria = _categoriaController.text.trim();
      final precio = double.parse(_precioController.text);
      final stock = int.parse(_stockController.text);

      try {
        if (widget.productoId == null) {
          // Lógica de Inserción
          await AppDatabase.instance.agregarProducto(ProductosCompanion(
            idUsuario: Value(widget.userId),
            nombre: Value(nombre),
            categoria: Value(categoria),
            precio: Value(precio),
            stock: Value(stock),
          ));
        } else {
          // Lógica de Actualización
          await AppDatabase.instance.actualizarProducto(Producto(
            id: widget.productoId!,
            idUsuario: widget.userId,
            nombre: nombre,
            categoria: categoria,
            precio: precio,
            stock: stock,
          ));
        }

        if (mounted) {
          Navigator.pop(context); // Regresar al panel tras el éxito
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar: $e')),
          );
        }
      }
    }
  }
}