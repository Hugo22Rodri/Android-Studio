import 'package:flutter/material.dart';
import '../database/supabase_service.dart';

import 'export_pdf_button.dart';

/// Dashboard superior con reportes de valor de inventario.
class InventoryDashboard extends StatelessWidget {
  final List<Producto> productos;

  const InventoryDashboard({super.key, required this.productos});

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
              DashboardCard(
                title: 'Inversión Total',
                value: '\$${inversionTotal.toStringAsFixed(2)}',
                icon: Icons.account_balance_wallet_outlined,
                color: Colors.green.shade50,
                iconColor: Colors.green,
              ),
              const SizedBox(width: 12),
              DashboardCard(
                title: 'Poco Stock',
                value: '$productosAlerta art.',
                icon: Icons.notification_important_outlined,
                color: Colors.red.shade50,
                iconColor: Colors.red,
              ),
              const SizedBox(width: 12),
              DashboardCard(
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
          child: ExportPdfButton(productos: productos),
        ),
      ],
    );
  }
}

/// Tarjeta individual para el dashboard con colores suaves.
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final MaterialColor iconColor;

  const DashboardCard({
    super.key,
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
