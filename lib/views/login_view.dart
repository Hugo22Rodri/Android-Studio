import 'package:flutter/material.dart';
import '../database/supabase_service.dart';
import 'main_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contraseniaController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _correoController.dispose();
    _contraseniaController.dispose();
    super.dispose();
  }

  Future<void> _ejecutarLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final userId = await SupabaseService.instance.verificarLogin(
          _correoController.text.trim(),
          _contraseniaController.text,
        );
        if (!mounted) return;
        if (userId != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainView(userId: userId)),
          );
        } else {
          _showError('Credenciales incorrectas');
        }
      } catch (e) {
        _showError('Error de conexión. Inténtalo de nuevo.');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFF50057),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF2962FF), Color(0xFF00E5FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Hero(
                          tag: 'app_logo',
                          child: Icon(
                            Icons.inventory_2_rounded,
                            size: 60,
                            color: const Color(0xFF2962FF),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '¡HOLA DE NUEVO!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2962FF),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Accede a tu inventario Stocky',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _correoController,
                          style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                          decoration: _inputDecoration(
                            label: 'CORREO ELECTRÓNICO',
                            icon: Icons.alternate_email_rounded,
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _contraseniaController,
                          obscureText: !_isPasswordVisible,
                          style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                          decoration: _inputDecoration(
                            label: 'CONTRASEÑA',
                            icon: Icons.lock_outline_rounded,
                            suffix: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                color: const Color(0xFF2962FF),
                              ),
                              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _ejecutarLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2962FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 5,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                                )
                              : const Text(
                                  'ENTRAR AHORA',
                                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
                                ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterView()),
                          ),
                          child: RichText(
                            text: const TextSpan(
                              text: '¿Eres nuevo? ',
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: 'CREAR CUENTA',
                                  style: TextStyle(
                                    color: Color(0xFF2962FF),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String label, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF2962FF)),
      prefixIcon: Icon(icon, color: const Color(0xFF2962FF)),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF0F4FF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFFF0F4FF))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 2)),
    );
  }
}
