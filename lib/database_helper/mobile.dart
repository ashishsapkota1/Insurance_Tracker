import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelHelper {
  static final ExcelHelper _excelHelper = ExcelHelper._internal();

  factory ExcelHelper() {
    return _excelHelper;
  }

  ExcelHelper._internal();

  Future<void> createExcel(Map<String, dynamic> familyData) async {
    final List<dynamic> newGeneral = familyData['newGeneral'];
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    Style globalStyle = workbook.styles.add('style');
    globalStyle.fontSize = 14;
    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    //Set data in the worksheet.
    sheet.getRangeByName('A1').columnWidth = 7.50;
    sheet.getRangeByName('B1:C1').columnWidth = 13.82;
    sheet.getRangeByName('D1').columnWidth = 13.20;
    sheet.getRangeByName('E1').columnWidth = 7.50;
    sheet.getRangeByName('F1').columnWidth = 7.50;

    sheet.getRangeByName('A1:F1').merge();
    sheet.getRangeByName('A1').setText('2080 Baishakh-Jestha-Ashadh');

    sheet.getRangeByName('A3').setText('रसिद नं.');
    sheet.getRangeByName('B3').setText('घरमुलीको नाम');
    sheet.getRangeByName('C3').setText('घरमुलीको बीमा नं.');
    sheet.getRangeByName('D3').setText('मोबाइल नं.');
    sheet.getRangeByName('E3').setText('सदस्य संख्या');
    sheet.getRangeByName('F3').setText('योगदान रकम');

    for (var fam in newGeneral){
      int cell = 4;
      sheet.getRangeByName('A$cell').setText(fam['receiptNo'].toString());
      cell++;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await saveAndLaunchFile(bytes, 'output.xlsx');
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
}