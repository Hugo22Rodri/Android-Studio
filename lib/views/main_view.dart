import 'package:flutter/material.dart';
import '../database/supabase_service.dart';
import '../services/pdf_service.dart';
import 'login_view.dart';
import 'gestion_producto_view.dart';

/// [MainView] es el panel central de administración de inventario.
/// 
/// Lógica de Negocio (Gestión de Stock):
/// - Se aplica una regla visual crítica: si un producto tiene [stock] <= 3, 
///   la interfaz activa un estado de alerta (Color rojo, Negrita y Etiqueta 'POCO STOCK').
/// - La búsqueda se realiza en tiempo real filtrando el Stream de la base de datos.
class MainView extends StatefulWidget {
  final String userId;
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
  Future<void> _logout() async {
    await SupabaseService.instance.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
        (route) => false,
      );
    }
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
      await SupabaseService.instance.eliminarProducto(producto.id);
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
      body: StreamBuilder<List<Producto>>(
        stream: SupabaseService.instance.obtenerProductosPrivados(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final productos = snapshot.data ?? [];
          final filtrados = productos.where((p) => p.nombre.toLowerCase().contains(_searchQuery)).toList();

          return Column(
            children: [
              // 1. Barra de búsqueda superior
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

              // 2. Dashboard de Reportes (Nueva Sección)
              _InventoryDashboard(productos: productos),

              const SizedBox(height: 8),

              // 3. Listado de productos
              Expanded(
                child: filtrados.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isEmpty ? 'No hay productos en inventario' : 'No se encontraron resultados',
                          style: TextStyle(color: colorScheme.secondary),
                        ),
                      )
                    : LayoutBuilder(builder: (context, constraints) {
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
                      }),
              ),
            ],
          );
        },
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

/// Dashboard superior con reportes de valor de inventario.
class _InventoryDashboard extends StatelessWidget {
  final List<Producto> productos;

  const _InventoryDashboard({required this.productos});

  @override
  Widget build(BuildContext context) {
    // 1. Inversión Total: Suma de (precio * stock) usando .fold()
    final double inversionTotal = productos.fold(0, (sum, p) => sum + (p.precio * p.stock));

    // 2. Productos en Alerta: stock <= 3 usando .where()
    final int productosAlerta = productos.where((p) => p.stock <= 3).length;

    // 3. Categoría con más stock acumulado
    final Map<String, int> categoriaStock = {};
    for (var p in productos) {
      categoriaStock[p.categoria] = (categoriaStock[p.categoria] ?? 0) + p.stock;
    }
    String topCategoria = "Ninguna";
    int maxStock = -1;
    categoriaStock.forEach((cat, stock) {
      if (stock > maxStock) {
        maxStock = stock;
        topCategoria = cat;
      }
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _DashboardCard(
                title: 'Inversión Total',
                value: '\$${inversionTotal.toStringAsFixed(2)}',
                icon: Icons.account_balance_wallet_outlined,
                color: Colors.green.shade50,
                iconColor: Colors.green,
              ),
              const SizedBox(width: 12),
              _DashboardCard(
                title: 'Poco Stock',
                value: '$productosAlerta art.',
                icon: Icons.notification_important_outlined,
                color: Colors.red.shade50,
                iconColor: Colors.red,
              ),
              const SizedBox(width: 12),
              _DashboardCard(
                title: 'Top Categoría',
                value: topCategoria,
                icon: Icons.analytics_outlined,
                color: Colors.indigo.shade50,
                iconColor: Colors.indigo,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: OutlinedButton.icon(
            onPressed: () {
              final productosMap = productos.map((p) => {
                'nombre': p.nombre,
                'categoria': p.categoria,
                'precio': p.precio,
                'stock': p.stock,
              }).toList();
              PdfService.generarReportePDF(productosMap, "Stocky Business");
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Exportar Reporte PDF'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

/// Tarjeta individual para el dashboard con colores suaves.
class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final MaterialColor iconColor;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: iconColor.shade800),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del Producto
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[100],
              child: producto.imagenUrl != null
                  ? Image.network(
                      producto.imagenUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      },
                    )
                  : const Icon(Icons.image, size: 40, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                        IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                        const SizedBox(width: 8),
                        IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Información del Producto
                Text(
                  producto.nombre,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${producto.precio.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: colorScheme.secondary, fontWeight: FontWeight.w600),
                ),
                const Divider(height: 20),
                
                // Visualización de Stock con Regla de Negocio
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Disponible', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text(
                          '${producto.stock} U.',
                          style: TextStyle(
                            fontSize: 12,
                            // REGLA IA: Alerta de stock bajo
                            color: esStockBajo ? Colors.red : Colors.black87,
                            fontWeight: esStockBajo ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    if (esStockBajo)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
