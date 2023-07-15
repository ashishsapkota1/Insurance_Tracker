import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
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
    PdfGrid grid = PdfGrid();
    PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    grid.columns.add(count: 6);

    grid.headers.add(1);
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'रसिद नं.';
    header.cells[1].value = 'घरमुलीको नाम';
    header.cells[2].value = 'घरमुलीको बीमा नं.';
    header.cells[3].value = 'मोबाइल नं.';
    header.cells[4].value = 'सदस्य संख्या';
    header.cells[5].value = 'योगदान रकम';
    // header.cells[0].value = 'Receipt';
    // header.cells[1].value = 'Name';
    // header.cells[2].value = 'HI Code';
    // header.cells[3].value = 'Mobile';
    // header.cells[4].value = 'Member';
    // header.cells[5].value = 'Amount';

    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        backgroundBrush: PdfBrushes.gray,
        textBrush: PdfBrushes.black,
        font: font);
    grid.draw(page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

    List<int> bytes = await document.save();
    document.dispose();
    saveAndLaunchFile(bytes, 'output.pdf');
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async{
    final path = await getExternalDocumentPath();
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    if (await Permission.manageExternalStorage.request().isGranted) {
      await OpenFile.open('$path/$fileName');
    }
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

  Future<PdfFont> getFont() async {
    final data = await rootBundle.load('assets/fonts/arial.ttf');
    final dataint = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
    final PdfFont font = PdfTrueTypeFont(dataint, 12);
    return font;
  }
}