import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFHelper {
  static final PDFHelper _pdfHelper = PDFHelper._internal();

  factory PDFHelper() {
    return _pdfHelper;
  }

  PDFHelper._internal();

  Future<void> createPDF() async {
    PdfDocument document = PdfDocument();
    document.pageSettings.size = PdfPageSize.a4;
    document.pages.add().graphics.drawString(
        'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
        brush: PdfBrushes.mediumVioletRed,
        bounds: const Rect.fromLTWH(170, 100, 0, 0)
    );
    List<int> bytes = await document.save();
    document.dispose();
    saveAndLaunchFile(bytes, 'output.pdf');
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async{
    final path = await getExternalDocumentPath();
    print(path);
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }

  static Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Download");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  }
}