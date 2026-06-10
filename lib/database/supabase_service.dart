import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

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

  User? get currentUser => _supabase.auth.currentUser;

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
    // 1. Registro en Supabase Auth con Metadata para tener el nombre disponible de inmediato
    final response = await _supabase.auth.signUp(
      email: correo,
      password: contrasenia,
      data: {'nombre_negocio': nombreNegocio},
    );

    if (response.user != null) {
      try {
        // 2. Intentar insertar/actualizar en la tabla 'usuarios'
        await _supabase.from('usuarios').upsert({
          'id': response.user!.id,
          'nombre_negocio': nombreNegocio,
          'correo': correo,
        });
      } catch (e) {
        debugPrint('Aviso: Error al guardar datos adicionales: $e');
      }
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

  // --- USUARIOS ---

  Future<Usuario?> obtenerDetallesUsuario(String userId) async {
    try {
      final data = await _supabase
          .from('usuarios')
          .select()
          .eq('id', userId)
          .maybeSingle();
      
      if (data == null) return null;
      return Usuario.fromJson(data);
    } catch (e) {
      debugPrint('Error al obtener detalles del usuario: $e');
      return null;
    }
  }

  Future<void> eliminarDatosCuenta(String userId) async {
    try {
      // 1. Borrar perfil (esto debería borrar productos por el CASCADE si configuraste el SQL)
      await _supabase.from('usuarios').delete().eq('id', userId);
      
      // 2. Por seguridad, borramos productos explícitamente si no hay cascada
      await _supabase.from('productos').delete().eq('id_usuario', userId);
      
      // 3. Cerrar sesión
      await logout();
    } catch (e) {
      debugPrint('Error al eliminar datos: $e');
      throw Exception('No se pudo eliminar la información');
    }
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
