import 'package:flutter/material.dart';
import '../database/connection.dart';
import 'main_view.dart';
import 'register_view.dart';

/// [LoginView] es la pantalla principal de acceso para la aplicación Stocky.
/// 
/// Flujo de operación:
/// 1. El usuario ingresa sus credenciales en el formulario.
/// 2. Se validan localmente los campos (no vacíos y formato de correo).
/// 3. Se invoca [verificarLogin] en la base de datos [AppDatabase].
/// 4. Si es exitoso, permite el acceso al sistema; de lo contrario, muestra un error.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Llave global para validaciones del formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar el texto de los inputs
  final _correoController = TextEditingController();
  final _contraseniaController = TextEditingController();

  // Estado de carga para el botón
  bool _isLoading = false;

  @override
  void dispose() {
    // Liberar controladores para evitar fugas de memoria
    _correoController.dispose();
    _contraseniaController.dispose();
    super.dispose();
  }

  /// Procesa el intento de inicio de sesión.
  Future<void> _ejecutarLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Llamada a la lógica de base de datos definida en connection.dart
        final userId = await AppDatabase.instance.verificarLogin(
          _correoController.text.trim(),
          _contraseniaController.text,
        );

        if (!mounted) return;

        if (userId != null) {
          // Login exitoso
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainView(userId: userId)),
            );
          }
        } else {
          // Credenciales incorrectas
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Correo o contraseña incorrectos'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        // Error de conexión o sistema
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error en el sistema: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores basados en el esquema de Material 3
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            // Restricción de ancho para que se vea bien en Web y Desktop
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 0, // Estilo minimalista Flat
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(color: colorScheme.outlineVariant, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Encabezado con el nombre de la App
                      const Icon(Icons.inventory_2_rounded, size: 48, color: Colors.blue),
                      const SizedBox(height: 16),
                      Text(
                        'Stocky',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              letterSpacing: -1,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Inicia sesión para gestionar tu negocio',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Campo: Correo Electrónico
                      TextFormField(
                        controller: _correoController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.blue.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colorScheme.outlineVariant),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Campo requerido';
                          if (!value.contains('@')) return 'Email inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo: Contraseña
                      TextFormField(
                        controller: _contraseniaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.blue.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colorScheme.outlineVariant),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Campo requerido';
                          if (value.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botón de Acción Principal (M3 Filled Button)
                      FilledButton(
                        onPressed: _isLoading ? null : _ejecutarLogin,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(
                                'Iniciar Sesión',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Enlace a Registro (RegisterView)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿No tienes cuenta?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RegisterView()),
                              );
                            },
                            child: const Text('Crea una ahora'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
