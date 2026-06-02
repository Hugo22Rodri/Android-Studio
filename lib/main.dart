import 'package:flutter/material.dart';
import 'database/connection.dart'; // importando la base de datos de stocky
import 'views/login_view.dart'; // importando la pantalla del login

/// Instancia global de la base de datos para ser accedida desde cualquier parte de la app.
late AppDatabase database;

void main() {
  // Aseguramos que los bindings de Flutter estén inicializados antes de usar la BD.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización global de la base de datos Drift usando la instancia singleton.
  database = AppDatabase.instance;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stocky - Gestión de Inventario',
      debugShowCheckedModeBanner: false,
      // Aplicamos un tema limpio basado en Material 3 con esquema de colores azul.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      // Configuramos el inicio de la aplicación directamente en la vista de Login.
      home: const LoginView(),
    );
  }
}
