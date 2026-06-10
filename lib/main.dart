import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/main_view.dart';
import 'views/welcome_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Error cargando .env: $e");
  }
  
  // Inicialización de Supabase usando variables de entorno
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Verificamos si existe una sesión activa para persistir el login
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'Stocky - Gestión de Inventario',
      debugShowCheckedModeBanner: false,
      // Soporte para Modo Claro y Oscuro
      themeMode: ThemeMode.system, 
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      // Si hay sesión, vamos al MainView; si no, a la pantalla de Bienvenida (Portada).
      home: session != null 
          ? MainView(userId: session.user.id) 
          : const WelcomeView(),
    );
  }
}
