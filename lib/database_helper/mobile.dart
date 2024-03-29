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

  Future<String> createExcel(int year, String session, Map<String, dynamic> familyData) async {

    final List<dynamic> newGeneral = familyData['newGeneral'];
    final List<dynamic> renewGeneral = familyData['renewGeneral'];
    final List<dynamic> newAged = familyData['newAged'];
    final List<dynamic> newDisabled = familyData['newDisabled'];

    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;

    sheet.getRangeByName('A1:H1').merge();

    sheet.getRangeByName('B2:G4').merge();
    sheet.getRangeByName('B2').setText('स्वास्थ्य बिमा नयाँ दर्ता तथा नविकरणको विवरण');
    sheet.getRangeByName('B2').cellStyle.fontSize = 16;

    sheet.getRangeByName('B5:G6').merge();
    sheet.getRangeByName('B5').setText('$year-$session');
    sheet.getRangeByName('B5').cellStyle.fontSize = 16;

    sheet.getRangeByName('C9:F9').merge();
    sheet.getRangeByName('C9').setText('साधारण परिवार - नयाँ दर्ता');
    sheet.getRangeByName('C9').cellStyle.fontSize = 12;

    sheet.getRangeByName('C11:F11').merge();
    sheet.getRangeByName('C11').setText('साधारण परिवार - नविकरण');
    sheet.getRangeByName('C11').cellStyle.fontSize = 12;

    sheet.getRangeByName('C13:F13').merge();
    sheet.getRangeByName('C13').setText('जेष्ठ नागरिक - नयाँ दर्ता');
    sheet.getRangeByName('C13').cellStyle.fontSize = 12;

    sheet.getRangeByName('C15:F15').merge();
    sheet.getRangeByName('C15').setText('अशक्त - नयाँ दर्ता');
    sheet.getRangeByName('C15').cellStyle.fontSize = 12;

    sheet.getRangeByName('B22:G22').merge();
    sheet.getRangeByName('B22').setText('दर्ता सहयोगी');
    sheet.getRangeByName('B22').cellStyle.fontSize = 12;

    sheet.getRangeByName('B23:G24').merge();
    sheet.getRangeByName('B23').setText('चण्डिका पौडेल');
    sheet.getRangeByName('B23').cellStyle.fontSize = 16;

    sheet.getRangeByName('B25:G25').merge();
    sheet.getRangeByName('B25').setText('बेनी, म्याग्दी');
    sheet.getRangeByName('B25').cellStyle.fontSize = 14;

    final Worksheet sheet1 = workbook.worksheets.addWithName('साधारण परिवार - नयाँ दर्ता');
    final Worksheet sheet2 = workbook.worksheets.addWithName('साधारण परिवार - नविकरण');
    final Worksheet sheet3 = workbook.worksheets.addWithName('जेष्ठ नागरिक - नयाँ दर्ता');
    final Worksheet sheet4 = workbook.worksheets.addWithName('अशक्त - नयाँ दर्ता');

    Style globalStyle = workbook.styles.add('style');
    globalStyle.fontSize = 14;
    sheet1.getRangeByName('A1:F1').merge();
    sheet1.getRangeByName('A1').setText('2080 Baishakh-Jestha-Ashadh साधारण परिवार - नयाँ दर्ता');
    sheet2.getRangeByName('A1:F1').merge();
    sheet2.getRangeByName('A1').setText('2080 Baishakh-Jestha-Ashadh साधारण परिवार - नविकरण');
    sheet3.getRangeByName('A1:F1').merge();
    sheet3.getRangeByName('A1').setText('2080 Baishakh-Jestha-Ashadh जेष्ठ नागरिक - नयाँ दर्ता');
    sheet4.getRangeByName('A1:F1').merge();
    sheet4.getRangeByName('A1').setText('2080 Baishakh-Jestha-Ashadh अशक्त - नयाँ दर्ता');

    if(newGeneral.isNotEmpty){
      final List<ExcelDataRow> generalNewRows = _buildReportDataRows(newGeneral);
      sheet1.importData(generalNewRows, 3, 1);
    }
    if(renewGeneral.isNotEmpty){
      final List<ExcelDataRow> generalRenewRows = _buildReportDataRows(renewGeneral);
      sheet2.importData(generalRenewRows, 3, 1);
    }
    if(newAged.isNotEmpty){
      final List<ExcelDataRow> agedNewRows = _buildReportDataRows(newAged);
      sheet3.importData(agedNewRows, 3, 1);
    }
    if(newDisabled.isNotEmpty){
      final List<ExcelDataRow> disabledNewRows = _buildReportDataRows(newDisabled);
      sheet4.importData(disabledNewRows, 3, 1);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    String path = await saveAndLaunchFile(bytes, '$year-$session.xlsx');
    return path;
  }

  Future<String> saveAndLaunchFile(List<int> bytes, String fileName) async{
    final path = await getExternalDocumentPath();
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    // if (await Permission.manageExternalStorage.request().isGranted) {
    //   await OpenFile.open('$path/$fileName');
    // }
    return '$path/$fileName';
  }

  List<ExcelDataRow> _buildReportDataRows(List<dynamic> details) {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
    excelDataRows = details.map<ExcelDataRow>((dynamic fam) {
      return ExcelDataRow(cells: <ExcelDataCell>[
        ExcelDataCell(columnHeader: 'रसिद नं.', value: fam['receiptNo']),
        ExcelDataCell(columnHeader: 'घरमुलीको नाम', value: fam['name']),
        ExcelDataCell(columnHeader: 'घरमुलीको बीमा नं.', value: fam['hiCode']),
        ExcelDataCell(columnHeader: 'मोबाइल नं.', value: fam['phnNo']),
        ExcelDataCell(columnHeader: 'सदस्य संख्या', value: fam['membersNo']),
        ExcelDataCell(columnHeader: 'योगदान रकम', value: fam['annualFee']),
        ExcelDataCell(columnHeader: 'कैफियत', value: fam['remarks']),
      ]);
    }).toList();

    return excelDataRows;
  }

  static Future<String> getExternalDocumentPath() async {
    var exStatus = await Permission.manageExternalStorage.request();
    Directory directory = Directory("");
    if(exStatus.isGranted){
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download");
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final exPath = directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  }
}