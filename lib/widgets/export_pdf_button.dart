import 'package:flutter/material.dart';
import '../database/supabase_service.dart';
import '../services/pdf_service.dart';

/// Botón estandarizado para exportar el reporte de inventario a PDF.
class ExportPdfButton extends StatelessWidget {
  final List<Producto> productos;
  final String nombreNegocio;

  const ExportPdfButton({
    super.key,
    required this.productos,
    this.nombreNegocio = "Stocky Business",
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => PdfService.generarReporteDesdeProductos(productos, nombreNegocio),
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text('Exportar Reporte PDF'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
