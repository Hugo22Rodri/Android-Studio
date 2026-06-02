import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../database/connection.dart';
import 'login_view.dart';

/// [RegisterView] permite a los nuevos usuarios crear una cuenta en Stocky.
/// 
/// Flujo de operación:
/// 1. El usuario completa los campos: Nombre, Correo y Contraseñas.
/// 2. Se validan los formatos, campos vacíos y la coincidencia de contraseñas.
/// 3. Se construye un [UsuariosCompanion] y se envía a [registrarUsuario].
/// 4. Tras el registro exitoso, se notifica al usuario y se redirige al Login.
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contraseniaController = TextEditingController();
  final _confirmarContraseniaController = TextEditingController();

  // Estados de la interfaz
  bool _isLoading = false;
  bool _obscureContrasenia = true;
  bool _obscureConfirmar = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _contraseniaController.dispose();
    _confirmarContraseniaController.dispose();
    super.dispose();
  }

  /// Ejecuta el proceso de registro en la base de datos.
  Future<void> _ejecutarRegistro() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Preparar el objeto para Drift
        final nuevoUsuario = UsuariosCompanion(
          nombreNegocio: Value(_nombreController.text.trim()),
          correo: Value(_correoController.text.trim()),
          contrasenia: Value(_contraseniaController.text),
        );

        // Guardar en la DB
        await AppDatabase.instance.registrarUsuario(nuevoUsuario);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta creada con éxito. ¡Inicia sesión!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navegar de regreso al Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      } catch (e) {
        if (mounted) {
          String errorMsg = 'Error al registrar';
          if (e.toString().contains('UNIQUE constraint failed')) {
            errorMsg = 'Este correo ya está registrado';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg), backgroundColor: Colors.redAccent),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 0,
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
                      // Encabezado consistente con Login
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
                        'Crear Cuenta',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Campo: Nombre Completo
                      TextFormField(
                        controller: _nombreController,
                        decoration: _inputDecoration('Nombre completo', Icons.person, colorScheme),
                        validator: (value) => (value == null || value.isEmpty) ? 'Ingresa tu nombre' : null,
                      ),
                      const SizedBox(height: 16),

                      // Campo: Correo Electrónico
                      TextFormField(
                        controller: _correoController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Correo electrónico', Icons.alternate_email, colorScheme),
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
                        obscureText: _obscureContrasenia,
                        decoration: _inputDecoration(
                          'Contraseña',
                          Icons.lock_outline,
                          colorScheme,
                          suffixIcon: IconButton(
                            icon: Icon(_obscureContrasenia ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscureContrasenia = !_obscureContrasenia),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Campo requerido';
                          if (value.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo: Confirmar Contraseña
                      TextFormField(
                        controller: _confirmarContraseniaController,
                        obscureText: _obscureConfirmar,
                        decoration: _inputDecoration(
                          'Confirmar contraseña',
                          Icons.lock_reset,
                          colorScheme,
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmar ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscureConfirmar = !_obscureConfirmar),
                          ),
                        ),
                        validator: (value) {
                          if (value != _contraseniaController.text) return 'Las contraseñas no coinciden';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Botón Registrar (Filled Button)
                      FilledButton(
                        onPressed: _isLoading ? null : _ejecutarRegistro,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Registrarse', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 16),

                      // Enlace al Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿Ya tienes cuenta?'),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginView()),
                            ),
                            child: const Text('Inicia sesión'),
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

  /// Estilo común para los campos de texto
  InputDecoration _inputDecoration(String label, IconData icon, ColorScheme colorScheme, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}
