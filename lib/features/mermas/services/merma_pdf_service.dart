import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/item_merma.dart';

class MermaPdfService {
  Future<void> generarYCompartirPDF(List<ItemMerma> mermas) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final fechaFormateada =
        '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    final datosTabla = mermas.map((item) {
      return [
        item.producto.codigoBarras,
        item.producto.descripcion,
        item.cantidad.toString(),
      ];
    }).toList();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de Mermas',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Text('Fecha de generación: $fechaFormateada',
                  style: const pw.TextStyle(
                      fontSize: 12, color: PdfColors.grey700)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Código', 'Descripción', 'Cant.'],
                data: datosTabla,
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.red800),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                },
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total de artículos mermados: ${mermas.fold<int>(0, (sum, item) => sum + item.cantidad)}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          );
        },
      ),
    );

    final directorioTemp = await getTemporaryDirectory();
    final nombreArchivo = 'Mermas_$fechaFormateada.pdf'
        .replaceAll('/', '-')
        .replaceAll(' ', '_')
        .replaceAll(':', '');
    final rutaArchivo = '${directorioTemp.path}/$nombreArchivo';

    final archivo = File(rutaArchivo);
    await archivo.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(rutaArchivo)],
      text: 'Envío el reporte de mermas actualizado al $fechaFormateada.',
      subject: 'Reporte de Mermas',
    );
  }
}
