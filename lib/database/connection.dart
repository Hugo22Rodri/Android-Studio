import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

part 'connection.g.dart';

// Estructura de la tabla Usuarios
class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombreNegocio => text()();
  TextColumn get correo => text().unique()();
  TextColumn get contrasenia => text()();
}

// Estructura de la tabla Productos (Relación 1:N)
class Productos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idUsuario => integer().references(Usuarios, #id)();
  TextColumn get nombre => text()();
  TextColumn get categoria => text()();
  RealColumn get precio => real()();
  IntColumn get stock => integer()();
}

/// Manejador de la base de datos Drift para Flutter Web con persistencia moderna (WASM).
@DriftDatabase(tables: [Usuarios, Productos])
class AppDatabase extends _$AppDatabase {
  /// Inicializa la base de datos utilizando el motor SQLite compilado a WASM.
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Configuración adicional al abrir la base de datos
  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // Activa el soporte para llaves foráneas (relación Usuarios <-> Productos)
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // Instancia única para toda la app (Singleton simple)
  static final AppDatabase instance = AppDatabase();

  // --- MÉTODOS CRUD ---

  /// Registra un nuevo usuario en el sistema.
  /// 
  /// Verifica si el [correo] ya existe mediante la restricción 'unique' de la tabla.
  /// Retorna el ID del usuario recién creado.
  Future<int> registrarUsuario(UsuariosCompanion usuario) async {
    return await into(usuarios).insert(usuario);
  }

  /// Valida las credenciales de un usuario.
  /// 
  /// [correo] El correo electrónico proporcionado.
  /// [contrasenia] La contraseña en texto plano (se recomienda hashing en producción).
  /// Retorna el ID del usuario si coinciden, de lo contrario retorna `null`.
  Future<int?> verificarLogin(String correo, String contrasenia) async {
    final query = select(usuarios)
      ..where((u) => u.correo.equals(correo) & u.contrasenia.equals(contrasenia));
    final user = await query.getSingleOrNull();
    return user?.id;
  }

  /// Agrega un nuevo producto al inventario de un usuario específico.
  /// 
  /// El producto quedará enlazado mediante el [idUsuario].
  Future<int> agregarProducto(ProductosCompanion producto) async {
    return await into(productos).insert(producto);
  }

  /// Obtiene un producto específico por su ID.
  Future<Producto?> obtenerProductoPorId(int id) {
    return (select(productos)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  /// Obtiene un flujo de datos (Stream) en tiempo real de los productos de un usuario.
  /// 
  /// [userId] ID del usuario dueño del inventario.
  /// Garantiza que el inventario sea privado filtrando por el ID del dueño.
  Stream<List<Producto>> obtenerProductosPrivados(int userId) {
    return (select(productos)..where((p) => p.idUsuario.equals(userId))).watch();
  }

  /// Actualiza la información de un producto existente.
  /// 
  /// El objeto [producto] debe contener el ID del registro a modificar.
  Future<bool> actualizarProducto(Producto producto) async {
    return await update(productos).replace(producto);
  }

  /// Elimina un producto de la base de datos.
  /// 
  /// [id] El identificador único del producto a eliminar.
  Future<int> eliminarProducto(int id) async {
    return await (delete(productos)..where((p) => p.id.equals(id))).go();
  }
}

/// Abre una conexión a la base de datos utilizando el motor WASM de Drift.
DatabaseConnection _openConnection() {
  final connection = DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'stocky_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      // ignore: avoid_print
      print('Aviso: El navegador no soporta algunas funciones de base de datos: ${result.missingFeatures}');
    }

    return result.resolvedExecutor;
  }));

  // Opcion 3: Interceptamos la conexión para imprimir los logs en consola
  return connection.intercept(_LogInterceptor());
}

/// Clase auxiliar para imprimir todas las consultas SQL en la consola.
class _LogInterceptor extends QueryInterceptor {
  @override
  Future<void> runSelect(QueryContext context, String sql, List<Object?> vars) async {
    print('SQL SELECT: $sql | Params: $vars');
    return super.runSelect(context, sql, vars);
  }

  @override
  Future<void> runStatement(QueryContext context, String sql, List<Object?> vars) async {
    print('SQL EXEC: $sql | Params: $vars');
    return super.runStatement(context, sql, vars);
  }
}
