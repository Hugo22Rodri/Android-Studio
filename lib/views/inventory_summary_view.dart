import 'package:flutter/material.dart';
import '../database/supabase_service.dart';
import '../services/pdf_service.dart';

class InventorySummaryView extends StatelessWidget {
  final List<Producto> productos;
  final String nombreNegocio;

  const InventorySummaryView({
    super.key,
    required this.productos,
    this.nombreNegocio = "Stocky Business",
  });

  @override
  Widget build(BuildContext context) {
    final double inversionTotal = productos.fold(0, (sum, p) => sum + (p.precio * p.stock));
    final int productosAlerta = productos.where((p) => p.stock <= 3).length;

    final Map<String, int> categoriaStock = {};
    for (var p in productos) {
      categoriaStock[p.categoria] = (categoriaStock[p.categoria] ?? 0) + p.stock;
    }
    String topCategoria = productos.isEmpty ? "NINGUNA" : "VARIOS";
    int maxStock = -1;
    categoriaStock.forEach((cat, stock) {
      if (stock > maxStock) {
        maxStock = stock;
        topCategoria = cat;
      }
    });

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
          'RESUMEN Y ESTADÍSTICAS',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _VibrantCard(
              title: 'INVERSIÓN TOTAL',
              value: '\$${inversionTotal.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet_rounded,
              colors: [const Color(0xFF2962FF), const Color(0xFF00E5FF)],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _VibrantCard(
                    title: 'ALERTAS',
                    value: '$productosAlerta',
                    icon: Icons.notification_important_rounded,
                    colors: [const Color(0xFFF50057), const Color(0xFFFF5252)],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _VibrantCard(
                    title: 'TOP CAT.',
                    value: topCategoria,
                    icon: Icons.analytics_rounded,
                    colors: [const Color(0xFF00C853), const Color(0xFFB2FF59)],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'HERRAMIENTAS DE CONTROL',
              style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2962FF), letterSpacing: 1.0),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2962FF).withOpacity(0.05),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(20),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF50057).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFF50057)),
                ),
                title: const Text('REPORTE PDF PROFESIONAL', style: TextStyle(fontWeight: FontWeight.w900)),
                subtitle: const Text('Descarga la lista completa con precios.'),
                trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF2962FF)),
                onTap: () {
                  final productosMap = productos.map((p) => {
                    'nombre': p.nombre,
                    'categoria': p.categoria,
                    'precio': p.precio,
                    'stock': p.stock,
                  }).toList();
                  PdfService.generarReportePDF(productosMap, nombreNegocio);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VibrantCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> colors;

  const _VibrantCard({required this.title, required this.value, required this.icon, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
