import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../database/supabase_service.dart';

class GestionProductoView extends StatefulWidget {
  final String userId;
  final int? productoId;

  const GestionProductoView({super.key, required this.userId, this.productoId});

  @override
  State<GestionProductoView> createState() => _GestionProductoViewState();
}

class _GestionProductoViewState extends State<GestionProductoView> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  Uint8List? _nuevaImagenBytes; // Bytes de la nueva imagen seleccionada
  String? _imagenUrlExistente; // URL de la imagen si estamos editando
  bool _subiendo = false;

  @override
  void initState() {
    super.initState();
    if (widget.productoId != null) {
      _cargarDatosProducto();
    }
  }

  Future<void> _cargarDatosProducto() async {
    final producto = await SupabaseService.instance.obtenerProductoPorId(widget.productoId!);
    if (producto != null) {
      setState(() {
        _nombreController.text = producto.nombre;
        _categoriaController.text = producto.categoria;
        _precioController.text = producto.precio.toString();
        _stockController.text = producto.stock.toString();
        _imagenUrlExistente = producto.imagen_url;
      });
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _nuevaImagenBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productoId == null ? 'Añadir Producto' : 'Editar Producto'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
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
                const SizedBox(height: 24),
                const Text('Imagen del Producto', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          image: _buildImageDecoration(),
                        ),
                        child: (_nuevaImagenBytes == null && _imagenUrlExistente == null)
                            ? const Icon(Icons.image, size: 50, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _seleccionarImagen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _subiendo ? null : _guardar,
                  child: _subiendo 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(widget.productoId == null ? 'Guardar Producto' : 'Actualizar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DecorationImage? _buildImageDecoration() {
    if (_nuevaImagenBytes != null) {
      return DecorationImage(image: MemoryImage(_nuevaImagenBytes!), fit: BoxFit.cover);
    } else if (_imagenUrlExistente != null) {
      return DecorationImage(image: NetworkImage(_imagenUrlExistente!), fit: BoxFit.cover);
    }
    return null;
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _subiendo = true);
      
      final nombre = _nombreController.text.trim();
      final categoria = _categoriaController.text.trim();
      final precio = double.parse(_precioController.text);
      final stock = int.parse(_stockController.text);

      try {
        String? finalImageUrl = _imagenUrlExistente;

        // Si el usuario seleccionó una nueva imagen, subirla a Storage
        if (_nuevaImagenBytes != null) {
          final url = await SupabaseService.instance.subirImagen(widget.userId, _nuevaImagenBytes!);
          if (url != null) {
            finalImageUrl = url;
          }
        }

        if (widget.productoId == null) {
          await SupabaseService.instance.agregarProducto(Producto(
            id: -1,
            idUsuario: widget.userId,
            nombre: nombre,
            categoria: categoria,
            precio: precio,
            stock: stock,
            imagen_url: finalImageUrl,
          ));
        } else {
          await SupabaseService.instance.actualizarProducto(Producto(
            id: widget.productoId!,
            idUsuario: widget.userId,
            nombre: nombre,
            categoria: categoria,
            precio: precio,
            stock: stock,
            imagen_url: finalImageUrl,
          ));
        }

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _subiendo = false);
      }
    }
  }
}
