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
  String? _categoriaSeleccionada;
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  final List<String> _categorias = [
    'plantas',
    'Bebidas',
    'Limpieza',
    'Electrónica',
    'Hogar',
    'Otros'
  ];

  Uint8List? _nuevaImagenBytes;
  String? _imagenUrlExistente;
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
        _categoriaSeleccionada = _categorias.contains(producto.categoria) 
            ? producto.categoria 
            : 'Otros';
        _precioController.text = producto.precio.toString();
        _stockController.text = producto.stock.toString();
        _imagenUrlExistente = producto.imagenUrl;
      });
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _nuevaImagenBytes = bytes);
    }
  }

  void _mostrarCalculadoraMargen() {
    final costController = TextEditingController();
    final marginController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('CALCULADORA DE MARGEN', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2962FF))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: costController,
              style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
              decoration: const InputDecoration(labelText: 'COSTO DEL PRODUCTO', prefixText: '\$'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: marginController,
              style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
              decoration: const InputDecoration(labelText: 'MARGEN DESEADO (%)', suffixText: '%'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          FilledButton(
            onPressed: () {
              final costo = double.tryParse(costController.text) ?? 0;
              final margen = double.tryParse(marginController.text) ?? 0;
              if (costo > 0 && margen > 0) {
                final sugerido = costo * (1 + (margen / 100));
                _precioController.text = sugerido.toStringAsFixed(2);
                Navigator.pop(context);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2962FF)),
            child: const Text('APLICAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2962FF), Color(0xFF00E5FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          widget.productoId == null ? 'NUEVO ARTÍCULO' : 'EDITAR ARTÍCULO',
          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2962FF).withValues(alpha: 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 260,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4FF),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: const Color(0xFF00E5FF), width: 2),
                              image: _buildImageDecoration(),
                            ),
                            child: (_nuevaImagenBytes == null && _imagenUrlExistente == null)
                                ? const Icon(Icons.add_a_photo_rounded, size: 50, color: Color(0xFF2962FF))
                                : null,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: FloatingActionButton.small(
                              onPressed: _seleccionarImagen,
                              backgroundColor: const Color(0xFFF50057),
                              child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _nombreController,
                      style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                      decoration: _inputDecoration('NOMBRE DEL PRODUCTO', Icons.shopping_bag_rounded),
                      validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: _categoriaSeleccionada,
                      style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                      decoration: _inputDecoration('CATEGORÍA', Icons.category_rounded),
                      items: _categorias.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) => setState(() => _categoriaSeleccionada = newValue),
                      validator: (v) => v == null ? 'Selecciona una categoría' : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _precioController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                            decoration: _inputDecoration(
                              'PRECIO', 
                              Icons.attach_money_rounded,
                              suffix: IconButton(
                                icon: const Icon(Icons.calculate_rounded, color: Color(0xFF2962FF)),
                                onPressed: _mostrarCalculadoraMargen,
                              ),
                            ),
                            validator: (v) => (v == null || double.tryParse(v) == null) ? 'Inválido' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                            decoration: _inputDecoration('STOCK', Icons.inventory_rounded),
                            validator: (v) => (v == null || int.tryParse(v) == null) ? 'Inválido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _subiendo ? null : _guardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                      ),
                      child: _subiendo 
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                        : const Text(
                            'GUARDAR CAMBIOS',
                            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DecorationImage? _buildImageDecoration() {
    if (_nuevaImagenBytes != null) return DecorationImage(image: MemoryImage(_nuevaImagenBytes!), fit: BoxFit.cover);
    if (_imagenUrlExistente != null) return DecorationImage(image: NetworkImage(_imagenUrlExistente!), fit: BoxFit.cover);
    return null;
  }

  InputDecoration _inputDecoration(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2962FF)),
      prefixIcon: Icon(icon, color: const Color(0xFF2962FF), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF0F4FF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 2)),
    );
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _subiendo = true);
      try {
        String? finalImageUrl = _imagenUrlExistente;
        if (_nuevaImagenBytes != null) {
          finalImageUrl = await SupabaseService.instance.subirImagen(widget.userId, _nuevaImagenBytes!);
        }
        final p = Producto(
          id: widget.productoId ?? -1,
          idUsuario: widget.userId,
          nombre: _nombreController.text.trim(),
          categoria: _categoriaSeleccionada!,
          precio: double.parse(_precioController.text),
          stock: int.parse(_stockController.text),
          imagenUrl: finalImageUrl,
        );
        if (widget.productoId == null) {
          await SupabaseService.instance.agregarProducto(p);
        } else {
          await SupabaseService.instance.actualizarProducto(p);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar')));
      } finally {
        if (mounted) setState(() => _subiendo = false);
      }
    }
  }
}
