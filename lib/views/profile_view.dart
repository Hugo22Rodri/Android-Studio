import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/supabase_service.dart';
import 'login_view.dart';

class ProfileView extends StatelessWidget {
  final String userId;
  const ProfileView({super.key, required this.userId});

  Future<void> _logout(BuildContext context) async {
    await SupabaseService.instance.logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
        (route) => false,
      );
    }
  }

  Future<void> _confirmarEliminacion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿ELIMINAR TODO?', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFF50057))),
        content: const Text('Esta acción borrará todos tus productos e información de negocio de forma permanente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF50057)),
            child: const Text('ELIMINAR MI CUENTA'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await SupabaseService.instance.eliminarDatosCuenta(userId);
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al eliminar')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario?>(
      future: SupabaseService.instance.obtenerDetallesUsuario(userId),
      builder: (context, snapshot) {
        Usuario? usuario = snapshot.data;
        
        // Recuperar nombre de la metadata si la tabla no tiene datos aún
        if (usuario == null && snapshot.connectionState == ConnectionState.done) {
          final authUser = Supabase.instance.client.auth.currentUser;
          if (authUser != null) {
            final metaNombre = authUser.userMetadata?['nombre_negocio'] ?? "MI NEGOCIO";
            usuario = Usuario(id: authUser.id, nombreNegocio: metaNombre, correo: authUser.email ?? "");
          }
        }

        final String nombreMostrar = usuario?.nombreNegocio.toUpperCase() ?? "CARGANDO...";

        return Scaffold(
          backgroundColor: const Color(0xFFF0F4FF),
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2962FF), Color(0xFF00E5FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            title: Text(
              nombreMostrar,
              style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2962FF).withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F4FF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(Icons.store_rounded, size: 60, color: Color(0xFF2962FF)),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              nombreMostrar,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2962FF),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "NOMBRE DEL NEGOCIO",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  usuario?.correo ?? "...",
                                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _OptionTile(
                        icon: Icons.info_outline_rounded,
                        title: 'VERSIÓN DEL SISTEMA',
                        subtitle: 'Stocky v1.0.2 - Pro',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      _OptionTile(
                        icon: Icons.logout_rounded,
                        title: 'CERRAR SESIÓN',
                        subtitle: 'Salir de la cuenta actual',
                        iconColor: const Color(0xFFF50057),
                        onTap: () => _logout(context),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => _confirmarEliminacion(context),
                        child: const Text(
                          'ELIMINAR TODOS MIS DATOS',
                          style: TextStyle(
                            color: Color(0xFFF50057),
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF2962FF)).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: iconColor ?? const Color(0xFF2962FF)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        onTap: onTap,
      ),
    );
  }
}
