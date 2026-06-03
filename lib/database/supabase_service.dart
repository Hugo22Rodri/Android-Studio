import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

/// Modelo de Usuario para la app
class Usuario {
  final String id;
  final String nombreNegocio;
  final String correo;

  Usuario({required this.id, required this.nombreNegocio, required this.correo});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombreNegocio: json['nombre_negocio'] ?? '',
      correo: json['correo'] ?? '',
    );
  }
}

/// Modelo de Producto para la app
class Producto {
  final int id;
  final String idUsuario;
  final String nombre;
  final String categoria;
  final double precio;
  final int stock;
  final String? imagenUrl; // Cambiado para coincidir con DB y evitar confusiones

  Producto({
    required this.id,
    required this.idUsuario,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.stock,
    this.imagenUrl,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      idUsuario: json['id_usuario'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      precio: (json['precio'] as num).toDouble(),
      stock: json['stock'],
      imagenUrl: json['imagen_url'],
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    final map = {
      'id_usuario': idUsuario,
      'nombre': nombre,
      'categoria': categoria,
      'precio': precio,
      'stock': stock,
      'imagen_url': imagenUrl,
    };
    if (includeId) {
      map['id'] = id;
    }
    return map;
  }
}

/// Servicio que maneja la comunicación con Supabase
class SupabaseService {
  static final SupabaseService instance = SupabaseService._();
  SupabaseService._();

  final _supabase = Supabase.instance.client;

  // --- STORAGE ---

  /// Sube una imagen al bucket 'productos' y retorna la URL pública
  Future<String?> subirImagen(String userId, Uint8List bytes) async {
    try {
      final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Subir archivo al bucket 'productos'
      await _supabase.storage.from('productos').uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
      );

      // Obtener la URL pública
      final String publicUrl = _supabase.storage.from('productos').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      // Error manejado silenciosamente
      return null;
    }
  }

  // --- AUTENTICACIÓN ---

  Future<void> registrarUsuario({
    required String nombreNegocio,
    required String correo,
    required String contrasenia,
  }) async {
    final response = await _supabase.auth.signUp(
      email: correo,
      password: contrasenia,
    );

    if (response.user != null) {
      // Asegúrate de que en Supabase la tabla 'usuarios' tenga las columnas: id, nombre_negocio, correo
      await _supabase.from('usuarios').insert({
        'id': response.user!.id, // Este es el UUID de Auth
        'nombre_negocio': nombreNegocio,
        'correo': correo,
      });
    }
  }

  Future<String?> verificarLogin(String correo, String contrasenia) async {
    final response = await _supabase.auth.signInWithPassword(
      email: correo,
      password: contrasenia,
    );
    return response.user?.id;
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  // --- PRODUCTOS ---

  Future<void> agregarProducto(Producto producto) async {
    await _supabase.from('productos').insert(producto.toJson());
  }

  Future<Producto?> obtenerProductoPorId(int id) async {
    final data = await _supabase
        .from('productos')
        .select()
        .eq('id', id)
        .maybeSingle();
    
    if (data == null) return null;
    return Producto.fromJson(data);
  }

  Stream<List<Producto>> obtenerProductosPrivados(String userId) {
    return _supabase
        .from('productos')
        .stream(primaryKey: ['id'])
        .eq('id_usuario', userId)
        .map((data) => data.map((json) => Producto.fromJson(json)).toList());
  }

  Future<void> actualizarProducto(Producto producto) async {
    await _supabase
        .from('productos')
        .update(producto.toJson())
        .eq('id', producto.id);
  }

  Future<void> eliminarProducto(int id) async {
    await _supabase.from('productos').delete().eq('id', id);
  }
}
