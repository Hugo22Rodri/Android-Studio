import 'package:flutter/material.dart';
import '../database/supabase_service.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreNegocioController = TextEditingController();
  final _correoController = TextEditingController();
  final _contraseniaController = TextEditingController();
  final _confirmarContraseniaController = TextEditingController();

  bool _isLoading = false;
  bool _obscureContrasenia = true;

  @override
  void dispose() {
    _nombreNegocioController.dispose();
    _correoController.dispose();
    _contraseniaController.dispose();
    _confirmarContraseniaController.dispose();
    super.dispose();
  }

  Future<void> _ejecutarRegistro() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await SupabaseService.instance.registrarUsuario(
          nombreNegocio: _nombreNegocioController.text.trim(),
          correo: _correoController.text.trim(),
          contrasenia: _contraseniaController.text,
        );
        if (!mounted) return;
        _showSuccess('¡CUENTA CREADA! INICIA SESIÓN.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      } catch (e) {
        String errorMsg = 'ERROR AL CREAR CUENTA';
        if (e.toString().contains('already registered')) {
          errorMsg = 'EL CORREO YA ESTÁ REGISTRADO';
        } else if (e.toString().contains('network')) {
          errorMsg = 'ERROR DE CONEXIÓN';
        }
        _showError(errorMsg);
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF00C853),
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
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [Color(0xFF2962FF), Color(0xFF00E5FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
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
                        const Text(
                          'NUEVO NEGOCIO',
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
                          'Únete a la red de Stocky',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _nombreNegocioController,
                          style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                          decoration: _inputDecoration('NOMBRE DEL NEGOCIO', Icons.storefront_rounded),
                          validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _correoController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                          decoration: _inputDecoration('CORREO ELECTRÓNICO', Icons.alternate_email_rounded),
                          validator: (v) => (v == null || !v.contains('@')) ? 'Email inválido' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _contraseniaController,
                          obscureText: _obscureContrasenia,
                          style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                          decoration: _inputDecoration(
                            'CONTRASEÑA',
                            Icons.lock_outline_rounded,
                            suffix: IconButton(
                              icon: Icon(
                                _obscureContrasenia ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                color: const Color(0xFF2962FF),
                              ),
                              onPressed: () => setState(() => _obscureContrasenia = !_obscureContrasenia),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmarContraseniaController,
                          obscureText: _obscureContrasenia,
                          style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                          decoration: _inputDecoration('CONFIRMAR CONTRASEÑA', Icons.lock_reset_rounded),
                          validator: (v) => (v != _contraseniaController.text) ? 'No coinciden' : null,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _ejecutarRegistro,
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
                                  'REGISTRARSE AHORA',
                                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
                                ),
                        ),
                        const SizedBox(height: 24),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2962FF)),
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

  InputDecoration _inputDecoration(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2962FF)),
      prefixIcon: Icon(icon, color: const Color(0xFF2962FF), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF0F4FF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFFF0F4FF))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 2)),
    );
  }
}
