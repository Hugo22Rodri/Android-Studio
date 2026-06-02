import 'package:flutter/material.dart';
import '../database/connection.dart';
import 'login_view.dart';
import 'gestion_producto_view.dart';

/// [MainView] es el panel central de administración de inventario.
/// 
/// Lógica de Negocio (Gestión de Stock):
/// - Se aplica una regla visual crítica: si un producto tiene [stock] <= 3, 
///   la interfaz activa un estado de alerta (Color rojo, Negrita y Etiqueta 'POCO STOCK').
/// - La búsqueda se realiza en tiempo real filtrando el Stream de la base de datos.
class MainView extends StatefulWidget {
  final int userId;
  const MainView({super.key, required this.userId});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Cierra la sesión y regresa al login
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  /// Confirma y ejecuta la eliminación de un producto
  Future<void> _confirmarEliminacion(Producto producto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar producto?'),
        content: Text('¿Estás seguro de que deseas eliminar "${producto.nombre}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await AppDatabase.instance.eliminarProducto(producto.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocky - Panel de Inventario'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda superior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              hintText: "Buscar productos...",
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              leading: const Icon(Icons.search),
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(colorScheme.surfaceContainerLow),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),

          // Stream de productos en tiempo real
          Expanded(
            child: StreamBuilder<List<Producto>>(
              stream: AppDatabase.instance.obtenerProductosPrivados(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final productos = snapshot.data ?? [];
                // Filtrado por búsqueda
                final filtrados = productos.where((p) => p.nombre.toLowerCase().contains(_searchQuery)).toList();

                if (filtrados.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty ? 'No hay productos en inventario' : 'No se encontraron resultados',
                      style: TextStyle(color: colorScheme.secondary),
                    ),
                  );
                }

                // Grid responsivo según el ancho de pantalla
                return LayoutBuilder(builder: (context, constraints) {
                  int crossAxisCount = (constraints.maxWidth / 300).floor().clamp(1, 4);
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filtrados.length,
                    itemBuilder: (context, index) {
                      final producto = filtrados[index];
                      return _ProductCard(
                        producto: producto,
                        onDelete: () => _confirmarEliminacion(producto),
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GestionProductoView(
                                userId: widget.userId,
                                productoId: producto.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GestionProductoView(userId: widget.userId),
            ),
          );
        },
        label: const Text('Nuevo Artículo'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
    );
  }
}

/// Widget interno para representar la tarjeta de cada producto.
class _ProductCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ProductCard({
    required this.producto,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    /// LOGICA DE IA (Regla de Stock Crítico):
    /// Detectamos si el stock está en niveles de alerta (<= 3).
    final bool esStockBajo = producto.stock <= 3;

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categoría y Acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    producto.categoria.toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 20)),
                    IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red)),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Información del Producto
            Text(
              producto.nombre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${producto.precio.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, color: colorScheme.secondary, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 24),
            
            // Visualización de Stock con Regla de Negocio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Disponible', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      '${producto.stock} Unidades',
                      style: TextStyle(
                        fontSize: 14,
                        // REGLA IA: Alerta de stock bajo
                        color: esStockBajo ? Colors.red : Colors.black87,
                        fontWeight: esStockBajo ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                if (esStockBajo)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'POCO STOCK',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
