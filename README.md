# Stocky - Sistema de Gestion de Inventarios

Stocky es una aplicacion profesional diseñada para la gestion eficiente de inventarios y control de stock. Desarrollada con el framework Flutter, la aplicacion destaca por su capacidad de persistencia de datos en entornos web utilizando SQLite mediante la tecnologia WebAssembly (WASM), proporcionando una experiencia de usuario fluida y reactiva.

## Introduccion

El objetivo de Stocky es proporcionar a los pequeños y medianos negocios una herramienta robusta para el seguimiento de sus productos. A diferencia de las aplicaciones web tradicionales que dependen enteramente de una API externa para cada operacion, Stocky implementa una base de datos local en el navegador, lo que reduce la latencia y mejora la seguridad de los datos del usuario.

## Caracteristicas Principales

### Gestion de Usuarios y Seguridad
La aplicacion implementa un sistema de registro y autenticacion. Cada negocio cuenta con un espacio de trabajo aislado, garantizando que los datos de inventario sean accesibles unicamente por el usuario propietario.

### Control de Inventario Completo
El sistema permite realizar todas las operaciones CRUD (Crear, Leer, Actualizar y Eliminar) sobre el catalogo de productos. Los campos soportados incluyen:
- Identificador unico.
- Nombre del producto.
- Clasificacion por categorias.
- Control de precios (formato decimal).
- Gestion de existencias (stock).

### Persistencia de Datos Avanzada
Mediante la integracion de la libreria Drift (anteriormente Moor), Stocky utiliza un motor SQLite compilado a WASM. Esto permite:
- Almacenamiento persistente en el navegador del cliente.
- Consultas SQL tipadas y seguras.
- Sincronizacion reactiva de la interfaz de usuario mediante Streams.

### Interfaz de Usuario Adaptativa
El diseño ha sido optimizado para funcionar tanto en resoluciones de escritorio como en dispositivos moviles, asegurando que la gestion del inventario se pueda realizar desde cualquier lugar.

## Stack Tecnologico

- Framework: Flutter
- Lenguaje: Dart
- Motor de Base de Datos: Drift (SQLite para Flutter)
- Formato de Ejecucion Web: WebAssembly (WASM)
- Gestion de Estado: Programacion Reactiva con Streams y Listenables

## Arquitectura de la Base de Datos

La estructura de datos se divide en dos entidades principales relacionadas:

1. Tabla Usuarios: Almacena la informacion del negocio, incluyendo nombre, correo electronico y credenciales de acceso.
2. Tabla Productos: Almacena los detalles de cada item del inventario, manteniendo una relacion de llave foranea con la tabla de usuarios para garantizar la integridad y privacidad de los datos.

La aplicacion hace uso de interceptores de consultas (QueryInterceptors) para el monitoreo y depuracion de las operaciones SQL en tiempo de ejecucion.

## Requisitos del Sistema

- Flutter SDK (Version estable mas reciente)
- Navegador Web moderno con soporte para WebAssembly (Chrome, Edge, Firefox o Safari)

## Instrucciones de Instalacion y Despliegue

### 1. Clonacion del Proyecto
Obtenga una copia local del repositorio:
```bash
git clone https://github.com/tu-usuario/stocky.git
cd stocky
```

### 2. Gestion de Dependencias
Descargue los paquetes necesarios definidos en el archivo pubspec.yaml:
```bash
flutter pub get
```

### 3. Generacion de Codigo
Dado que el proyecto utiliza generacion de codigo para la capa de persistencia, es necesario ejecutar el generador:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Ejecucion
Para iniciar la aplicacion en el entorno de desarrollo web:
```bash
flutter run -d chrome
```

## Estructura de Directorios

- lib/database/: Contiene la definicion del esquema de la base de datos, las tablas y la configuracion de la conexion WASM.
- lib/views/: Implementacion de las pantallas de la interfaz de usuario, incluyendo el inicio de sesion, el panel principal y los formularios de gestion.
- web/: Incluye los archivos necesarios para el motor SQLite (sqlite3.wasm y drift_worker.js).

## Consideraciones de Desarrollo

Si se realizan modificaciones en los archivos de definicion de tablas (lib/database/connection.dart), se debe regenerar el archivo de soporte (connection.g.dart) utilizando el comando de build_runner mencionado anteriormente.

## Licencia

Este proyecto se distribuye bajo la Licencia MIT. Para mas detalles, consulte el archivo LICENSE en la raiz del repositorio.

## Desarrolladores

- Adrian
- Odelkis
