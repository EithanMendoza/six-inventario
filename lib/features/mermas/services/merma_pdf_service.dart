import 'dart:io';
import 'package:flutter/foundation.dart'; // NECESARIO PARA compute
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/item_merma.dart';

class MermaPdfService {
  Future<void> generarYCompartirPDF(List<ItemMerma> mermas) async {
    final now = DateTime.now();
    final fechaFormateada =
        '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    // 1. Extraer a primitivos (Strings) para no romper el Isolate con objetos de Isar
    final datosAislados = mermas
        .map((item) => [
              item.producto.codigoBarras,
              item.producto.descripcion,
              item.cantidad.toString(),
            ])
        .toList();

    // 2. Mover la carga pesada (construcción y render del PDF) a un Isolate
    final bytesPdf = await compute(_generarPdfPesado, {
      'fecha': fechaFormateada,
      'datos': datosAislados,
      'total': mermas.fold<int>(0, (sum, item) => sum + item.cantidad),
    });

    // 3. Escribir archivo y compartir (Hilo principal, pero es instantáneo)
    final directorioTemp = await getTemporaryDirectory();
    final nombreArchivo = 'Mermas_$fechaFormateada.pdf'
        .replaceAll('/', '-')
        .replaceAll(' ', '_')
        .replaceAll(':', '');
    final rutaArchivo = '${directorioTemp.path}/$nombreArchivo';

    final archivo = File(rutaArchivo);
    await archivo.writeAsBytes(bytesPdf);

    await Share.shareXFiles(
      [XFile(rutaArchivo)],
      text: 'Envío el reporte de mermas actualizado al $fechaFormateada.',
      subject: 'Reporte de Mermas',
    );
  }

  // Función estática pura requerida por compute()
  static Future<Uint8List> _generarPdfPesado(Map<String, dynamic> args) async {
    final pdf = pw.Document();
    final String fecha = args['fecha'];
    final List<List<String>> datos = args['datos'];
    final int total = args['total'];

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
              pw.Text('Fecha de generación: $fecha',
                  style: const pw.TextStyle(
                      fontSize: 12, color: PdfColors.grey700)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Código', 'Descripción', 'Cant.'],
                data: datos,
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
                child: pw.Text('Total de artículos mermados: $total',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 14)),
              ),
            ],
          );
        },
      ),
    );

    return await pdf
        .save(); // Este es el proceso que tomaba el 90% de los recursos
  }
}
