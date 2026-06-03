import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

/// Servicio para la generación de reportes en PDF.
class PdfService {
  /// Genera y abre el diálogo de impresión para un reporte de inventario.
  /// 
  /// [productos] debe ser una lista de mapas con las llaves: 
  /// 'nombre', 'categoria', 'precio', 'stock'.
  static Future<void> generarReportePDF(List<Map<String, dynamic>> productos, String nombreNegocio) async {
    final pdf = pw.Document();
    final date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    // Calcular la inversión total
    final double inversionTotal = productos.fold(0, (sum, p) {
      final precio = (p['precio'] ?? 0).toDouble();
      final stock = (p['stock'] ?? 0).toInt();
      return sum + (precio * stock);
    });

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Encabezado Profesional
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    nombreNegocio.toUpperCase(),
                    style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
                  ),
                  pw.Text(
                    'Reporte de Inventario Stocky',
                    style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Fecha de Emisión:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.Text(date, style: pw.TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 2, color: PdfColors.blueGrey),
          pw.SizedBox(height: 20),

          // Tabla de Productos
          pw.TableHelper.fromTextArray(
            headers: ['Producto', 'Categoría', 'Precio', 'Stock', 'Subtotal'],
            data: productos.map((p) {
              final precio = (p['precio'] ?? 0).toDouble();
              final stock = (p['stock'] ?? 0).toInt();
              return [
                p['nombre'],
                p['categoria'],
                '\$${precio.toStringAsFixed(2)}',
                '$stock',
                '\$${(precio * stock).toStringAsFixed(2)}',
              ];
            }).toList(),
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
            cellHeight: 25,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
          ),
          
          pw.SizedBox(height: 20),

          // Resumen Final
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border(top: pw.BorderSide(color: PdfColors.blueGrey, width: 2)),
              ),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    'INVERSIÓN TOTAL: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                  ),
                  pw.Text(
                    '\$${inversionTotal.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, color: PdfColors.blue800),
                  ),
                ],
              ),
            ),
          ),

          // Pie de página
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 40),
            child: pw.Center(
              child: pw.Text(
                'Este documento es un reporte generado automáticamente por Stocky Inventory Management.',
                style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500, fontStyle: pw.FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );

    // Abrir diálogo de impresión/guardado nativo
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Reporte_${nombreNegocio.replaceAll(' ', '_')}.pdf',
    );
  }
}
