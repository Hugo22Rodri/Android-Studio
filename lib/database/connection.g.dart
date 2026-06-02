// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// ignore_for_file: type=lint
class $UsuariosTable extends Usuarios with TableInfo<$UsuariosTable, Usuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreNegocioMeta = const VerificationMeta(
    'nombreNegocio',
  );
  @override
  late final GeneratedColumn<String> nombreNegocio = GeneratedColumn<String>(
    'nombre_negocio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correoMeta = const VerificationMeta('correo');
  @override
  late final GeneratedColumn<String> correo = GeneratedColumn<String>(
    'correo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _contraseniaMeta = const VerificationMeta(
    'contrasenia',
  );
  @override
  late final GeneratedColumn<String> contrasenia = GeneratedColumn<String>(
    'contrasenia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombreNegocio,
    correo,
    contrasenia,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Usuario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre_negocio')) {
      context.handle(
        _nombreNegocioMeta,
        nombreNegocio.isAcceptableOrUnknown(
          data['nombre_negocio']!,
          _nombreNegocioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreNegocioMeta);
    }
    if (data.containsKey('correo')) {
      context.handle(
        _correoMeta,
        correo.isAcceptableOrUnknown(data['correo']!, _correoMeta),
      );
    } else if (isInserting) {
      context.missing(_correoMeta);
    }
    if (data.containsKey('contrasenia')) {
      context.handle(
        _contraseniaMeta,
        contrasenia.isAcceptableOrUnknown(
          data['contrasenia']!,
          _contraseniaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contraseniaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Usuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Usuario(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombreNegocio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_negocio'],
      )!,
      correo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correo'],
      )!,
      contrasenia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contrasenia'],
      )!,
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }
}

class Usuario extends DataClass implements Insertable<Usuario> {
  final int id;
  final String nombreNegocio;
  final String correo;
  final String contrasenia;
  const Usuario({
    required this.id,
    required this.nombreNegocio,
    required this.correo,
    required this.contrasenia,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre_negocio'] = Variable<String>(nombreNegocio);
    map['correo'] = Variable<String>(correo);
    map['contrasenia'] = Variable<String>(contrasenia);
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      nombreNegocio: Value(nombreNegocio),
      correo: Value(correo),
      contrasenia: Value(contrasenia),
    );
  }

  factory Usuario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Usuario(
      id: serializer.fromJson<int>(json['id']),
      nombreNegocio: serializer.fromJson<String>(json['nombreNegocio']),
      correo: serializer.fromJson<String>(json['correo']),
      contrasenia: serializer.fromJson<String>(json['contrasenia']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombreNegocio': serializer.toJson<String>(nombreNegocio),
      'correo': serializer.toJson<String>(correo),
      'contrasenia': serializer.toJson<String>(contrasenia),
    };
  }

  Usuario copyWith({
    int? id,
    String? nombreNegocio,
    String? correo,
    String? contrasenia,
  }) => Usuario(
    id: id ?? this.id,
    nombreNegocio: nombreNegocio ?? this.nombreNegocio,
    correo: correo ?? this.correo,
    contrasenia: contrasenia ?? this.contrasenia,
  );
  Usuario copyWithCompanion(UsuariosCompanion data) {
    return Usuario(
      id: data.id.present ? data.id.value : this.id,
      nombreNegocio: data.nombreNegocio.present
          ? data.nombreNegocio.value
          : this.nombreNegocio,
      correo: data.correo.present ? data.correo.value : this.correo,
      contrasenia: data.contrasenia.present
          ? data.contrasenia.value
          : this.contrasenia,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Usuario(')
          ..write('id: $id, ')
          ..write('nombreNegocio: $nombreNegocio, ')
          ..write('correo: $correo, ')
          ..write('contrasenia: $contrasenia')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombreNegocio, correo, contrasenia);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Usuario &&
          other.id == this.id &&
          other.nombreNegocio == this.nombreNegocio &&
          other.correo == this.correo &&
          other.contrasenia == this.contrasenia);
}

class UsuariosCompanion extends UpdateCompanion<Usuario> {
  final Value<int> id;
  final Value<String> nombreNegocio;
  final Value<String> correo;
  final Value<String> contrasenia;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.nombreNegocio = const Value.absent(),
    this.correo = const Value.absent(),
    this.contrasenia = const Value.absent(),
  });
  UsuariosCompanion.insert({
    this.id = const Value.absent(),
    required String nombreNegocio,
    required String correo,
    required String contrasenia,
  }) : nombreNegocio = Value(nombreNegocio),
       correo = Value(correo),
       contrasenia = Value(contrasenia);
  static Insertable<Usuario> custom({
    Expression<int>? id,
    Expression<String>? nombreNegocio,
    Expression<String>? correo,
    Expression<String>? contrasenia,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombreNegocio != null) 'nombre_negocio': nombreNegocio,
      if (correo != null) 'correo': correo,
      if (contrasenia != null) 'contrasenia': contrasenia,
    });
  }

  UsuariosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombreNegocio,
    Value<String>? correo,
    Value<String>? contrasenia,
  }) {
    return UsuariosCompanion(
      id: id ?? this.id,
      nombreNegocio: nombreNegocio ?? this.nombreNegocio,
      correo: correo ?? this.correo,
      contrasenia: contrasenia ?? this.contrasenia,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombreNegocio.present) {
      map['nombre_negocio'] = Variable<String>(nombreNegocio.value);
    }
    if (correo.present) {
      map['correo'] = Variable<String>(correo.value);
    }
    if (contrasenia.present) {
      map['contrasenia'] = Variable<String>(contrasenia.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('nombreNegocio: $nombreNegocio, ')
          ..write('correo: $correo, ')
          ..write('contrasenia: $contrasenia')
          ..write(')'))
        .toString();
  }
}

class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, Producto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idUsuarioMeta = const VerificationMeta(
    'idUsuario',
  );
  @override
  late final GeneratedColumn<int> idUsuario = GeneratedColumn<int>(
    'id_usuario',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
    'precio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idUsuario,
    nombre,
    categoria,
    precio,
    stock,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Producto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_usuario')) {
      context.handle(
        _idUsuarioMeta,
        idUsuario.isAcceptableOrUnknown(data['id_usuario']!, _idUsuarioMeta),
      );
    } else if (isInserting) {
      context.missing(_idUsuarioMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    } else if (isInserting) {
      context.missing(_stockMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Producto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Producto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idUsuario: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_usuario'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class Producto extends DataClass implements Insertable<Producto> {
  final int id;
  final int idUsuario;
  final String nombre;
  final String categoria;
  final double precio;
  final int stock;
  const Producto({
    required this.id,
    required this.idUsuario,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.stock,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_usuario'] = Variable<int>(idUsuario);
    map['nombre'] = Variable<String>(nombre);
    map['categoria'] = Variable<String>(categoria);
    map['precio'] = Variable<double>(precio);
    map['stock'] = Variable<int>(stock);
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      idUsuario: Value(idUsuario),
      nombre: Value(nombre),
      categoria: Value(categoria),
      precio: Value(precio),
      stock: Value(stock),
    );
  }

  factory Producto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Producto(
      id: serializer.fromJson<int>(json['id']),
      idUsuario: serializer.fromJson<int>(json['idUsuario']),
      nombre: serializer.fromJson<String>(json['nombre']),
      categoria: serializer.fromJson<String>(json['categoria']),
      precio: serializer.fromJson<double>(json['precio']),
      stock: serializer.fromJson<int>(json['stock']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idUsuario': serializer.toJson<int>(idUsuario),
      'nombre': serializer.toJson<String>(nombre),
      'categoria': serializer.toJson<String>(categoria),
      'precio': serializer.toJson<double>(precio),
      'stock': serializer.toJson<int>(stock),
    };
  }

  Producto copyWith({
    int? id,
    int? idUsuario,
    String? nombre,
    String? categoria,
    double? precio,
    int? stock,
  }) => Producto(
    id: id ?? this.id,
    idUsuario: idUsuario ?? this.idUsuario,
    nombre: nombre ?? this.nombre,
    categoria: categoria ?? this.categoria,
    precio: precio ?? this.precio,
    stock: stock ?? this.stock,
  );
  Producto copyWithCompanion(ProductosCompanion data) {
    return Producto(
      id: data.id.present ? data.id.value : this.id,
      idUsuario: data.idUsuario.present ? data.idUsuario.value : this.idUsuario,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      precio: data.precio.present ? data.precio.value : this.precio,
      stock: data.stock.present ? data.stock.value : this.stock,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Producto(')
          ..write('id: $id, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('precio: $precio, ')
          ..write('stock: $stock')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idUsuario, nombre, categoria, precio, stock);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Producto &&
          other.id == this.id &&
          other.idUsuario == this.idUsuario &&
          other.nombre == this.nombre &&
          other.categoria == this.categoria &&
          other.precio == this.precio &&
          other.stock == this.stock);
}

class ProductosCompanion extends UpdateCompanion<Producto> {
  final Value<int> id;
  final Value<int> idUsuario;
  final Value<String> nombre;
  final Value<String> categoria;
  final Value<double> precio;
  final Value<int> stock;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.idUsuario = const Value.absent(),
    this.nombre = const Value.absent(),
    this.categoria = const Value.absent(),
    this.precio = const Value.absent(),
    this.stock = const Value.absent(),
  });
  ProductosCompanion.insert({
    this.id = const Value.absent(),
    required int idUsuario,
    required String nombre,
    required String categoria,
    required double precio,
    required int stock,
  }) : idUsuario = Value(idUsuario),
       nombre = Value(nombre),
       categoria = Value(categoria),
       precio = Value(precio),
       stock = Value(stock);
  static Insertable<Producto> custom({
    Expression<int>? id,
    Expression<int>? idUsuario,
    Expression<String>? nombre,
    Expression<String>? categoria,
    Expression<double>? precio,
    Expression<int>? stock,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idUsuario != null) 'id_usuario': idUsuario,
      if (nombre != null) 'nombre': nombre,
      if (categoria != null) 'categoria': categoria,
      if (precio != null) 'precio': precio,
      if (stock != null) 'stock': stock,
    });
  }

  ProductosCompanion copyWith({
    Value<int>? id,
    Value<int>? idUsuario,
    Value<String>? nombre,
    Value<String>? categoria,
    Value<double>? precio,
    Value<int>? stock,
  }) {
    return ProductosCompanion(
      id: id ?? this.id,
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idUsuario.present) {
      map['id_usuario'] = Variable<int>(idUsuario.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('precio: $precio, ')
          ..write('stock: $stock')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $ProductosTable productos = $ProductosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [usuarios, productos];
}

typedef $$UsuariosTableCreateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      required String nombreNegocio,
      required String correo,
      required String contrasenia,
    });
typedef $$UsuariosTableUpdateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      Value<String> nombreNegocio,
      Value<String> correo,
      Value<String> contrasenia,
    });

final class $$UsuariosTableReferences
    extends BaseReferences<_$AppDatabase, $UsuariosTable, Usuario> {
  $$UsuariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductosTable, List<Producto>>
  _productosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productos,
    aliasName: $_aliasNameGenerator(db.usuarios.id, db.productos.idUsuario),
  );

  $$ProductosTableProcessedTableManager get productosRefs {
    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.idUsuario.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreNegocio => $composableBuilder(
    column: $table.nombreNegocio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contrasenia => $composableBuilder(
    column: $table.contrasenia,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productosRefs(
    Expression<bool> Function($$ProductosTableFilterComposer f) f,
  ) {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idUsuario,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreNegocio => $composableBuilder(
    column: $table.nombreNegocio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contrasenia => $composableBuilder(
    column: $table.contrasenia,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreNegocio => $composableBuilder(
    column: $table.nombreNegocio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get correo =>
      $composableBuilder(column: $table.correo, builder: (column) => column);

  GeneratedColumn<String> get contrasenia => $composableBuilder(
    column: $table.contrasenia,
    builder: (column) => column,
  );

  Expression<T> productosRefs<T extends Object>(
    Expression<T> Function($$ProductosTableAnnotationComposer a) f,
  ) {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idUsuario,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTable,
          Usuario,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (Usuario, $$UsuariosTableReferences),
          Usuario,
          PrefetchHooks Function({bool productosRefs})
        > {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombreNegocio = const Value.absent(),
                Value<String> correo = const Value.absent(),
                Value<String> contrasenia = const Value.absent(),
              }) => UsuariosCompanion(
                id: id,
                nombreNegocio: nombreNegocio,
                correo: correo,
                contrasenia: contrasenia,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombreNegocio,
                required String correo,
                required String contrasenia,
              }) => UsuariosCompanion.insert(
                id: id,
                nombreNegocio: nombreNegocio,
                correo: correo,
                contrasenia: contrasenia,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsuariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productosRefs) db.productos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productosRefs)
                    await $_getPrefetchedData<
                      Usuario,
                      $UsuariosTable,
                      Producto
                    >(
                      currentTable: table,
                      referencedTable: $$UsuariosTableReferences
                          ._productosRefsTable(db),
                      managerFromTypedResult: (p0) => $$UsuariosTableReferences(
                        db,
                        table,
                        p0,
                      ).productosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.idUsuario == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTable,
      Usuario,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (Usuario, $$UsuariosTableReferences),
      Usuario,
      PrefetchHooks Function({bool productosRefs})
    >;
typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      required int idUsuario,
      required String nombre,
      required String categoria,
      required double precio,
      required int stock,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      Value<int> idUsuario,
      Value<String> nombre,
      Value<String> categoria,
      Value<double> precio,
      Value<int> stock,
    });

final class $$ProductosTableReferences
    extends BaseReferences<_$AppDatabase, $ProductosTable, Producto> {
  $$ProductosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _idUsuarioTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.productos.idUsuario, db.usuarios.id),
      );

  $$UsuariosTableProcessedTableManager get idUsuario {
    final $_column = $_itemColumn<int>('id_usuario')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idUsuarioTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  $$UsuariosTableFilterComposer get idUsuario {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idUsuario,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get idUsuario {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idUsuario,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  $$UsuariosTableAnnotationComposer get idUsuario {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idUsuario,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTable,
          Producto,
          $$ProductosTableFilterComposer,
          $$ProductosTableOrderingComposer,
          $$ProductosTableAnnotationComposer,
          $$ProductosTableCreateCompanionBuilder,
          $$ProductosTableUpdateCompanionBuilder,
          (Producto, $$ProductosTableReferences),
          Producto,
          PrefetchHooks Function({bool idUsuario})
        > {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idUsuario = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<double> precio = const Value.absent(),
                Value<int> stock = const Value.absent(),
              }) => ProductosCompanion(
                id: id,
                idUsuario: idUsuario,
                nombre: nombre,
                categoria: categoria,
                precio: precio,
                stock: stock,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idUsuario,
                required String nombre,
                required String categoria,
                required double precio,
                required int stock,
              }) => ProductosCompanion.insert(
                id: id,
                idUsuario: idUsuario,
                nombre: nombre,
                categoria: categoria,
                precio: precio,
                stock: stock,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idUsuario = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idUsuario) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idUsuario,
                                referencedTable: $$ProductosTableReferences
                                    ._idUsuarioTable(db),
                                referencedColumn: $$ProductosTableReferences
                                    ._idUsuarioTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTable,
      Producto,
      $$ProductosTableFilterComposer,
      $$ProductosTableOrderingComposer,
      $$ProductosTableAnnotationComposer,
      $$ProductosTableCreateCompanionBuilder,
      $$ProductosTableUpdateCompanionBuilder,
      (Producto, $$ProductosTableReferences),
      Producto,
      PrefetchHooks Function({bool idUsuario})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
}
