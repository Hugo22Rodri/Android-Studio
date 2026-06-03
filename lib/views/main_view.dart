import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import '../database/supabase_service.dart';
import 'gestion_producto_view.dart';
import 'profile_view.dart';
import 'inventory_summary_view.dart';

class MainView extends StatefulWidget {
  final String userId;
  const MainView({super.key, required this.userId});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  late Stream<List<Producto>> _productosStream;
  String _sortBy = 'nombre';

  @override
  void initState() {
    super.initState();
    _actualizarStream();
  }

  void _actualizarStream() {
    setState(() {
      _productosStream = SupabaseService.instance.obtenerProductosPrivados(widget.userId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmarEliminacion(Producto producto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Eliminar de Stocky?'),
        content: Text('Estás a punto de borrar "${producto.nombre}".'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF50057), elevation: 0),
            child: const Text('SÍ, ELIMINAR'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await SupabaseService.instance.eliminarProducto(producto.id);
      _actualizarStream();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Producto eliminado con éxito'),
            backgroundColor: const Color(0xFFF50057),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'STOCKY',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          StreamBuilder<List<Producto>>(
            stream: _productosStream,
            builder: (context, snapshot) {
              final productos = snapshot.data ?? [];
              return IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InventorySummaryView(productos: productos))),
                icon: const Icon(Icons.insights_rounded),
                tooltip: 'Analíticas',
              );
            },
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileView(userId: widget.userId))),
            icon: const Icon(Icons.account_circle_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<Producto>>(
        stream: _productosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          List<Producto> productos = snapshot.data ?? [];
          final filtrados = productos.where((p) => p.nombre.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Buscar productos...',
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2962FF)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filtrados.isEmpty
                    ? _EmptyState(isSearch: _searchQuery.isNotEmpty)
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 350,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          mainAxisExtent: 300,
                        ),
                        itemCount: filtrados.length,
                        itemBuilder: (context, index) => _ProductCard(
                          producto: filtrados[index],
                          onDelete: () => _confirmarEliminacion(filtrados[index]),
                          onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GestionProductoView(userId: widget.userId, productoId: filtrados[index].id))),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GestionProductoView(userId: widget.userId))),
        backgroundColor: const Color(0xFFF50057),
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add_rounded, size: 40),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ProductCard({required this.producto, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final esStockBajo = producto.stock <= 3;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2962FF).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  producto.imagenUrl != null
                      ? CachedNetworkImage(
                          imageUrl: producto.imagenUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: Colors.blue.shade50),
                        )
                      : Container(color: Colors.blue.shade50, child: const Icon(Icons.image, size: 50, color: Colors.blue)),
                  if (esStockBajo)
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF50057),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text('¡URGENTE!', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.nombre.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14), maxLines: 1),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${producto.precio.toStringAsFixed(2)}',
                        style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: esStockBajo ? const Color(0xFFF50057).withOpacity(0.1) : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${producto.stock} UNID.',
                          style: TextStyle(
                            color: esStockBajo ? const Color(0xFFF50057) : Colors.green,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2962FF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Icon(Icons.edit_rounded, size: 18),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_forever_rounded, color: Color(0xFFF50057)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isSearch;
  const _EmptyState({required this.isSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_rounded, size: 100, color: const Color(0xFF2962FF).withOpacity(0.2)),
          const SizedBox(height: 20),
          const Text('¡TU INVENTARIO ESTÁ LISTO!', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2962FF))),
        ],
      ),
    );
  }
}
