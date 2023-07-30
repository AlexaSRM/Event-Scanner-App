import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gsheets/gsheets.dart';

class GSheetsService {
  final GSheets _gsheets;

  GSheetsService() : _gsheets = GSheets(dotenv.env['CREDENTIALS'] ?? '');

  Future<bool> checkAttendeeExists(String regNo) async {
    final ss = await _gsheets.spreadsheet(dotenv.env['SPREADSHEET_ID'] ?? '');
    final sheet = ss.worksheetByTitle('Sheet1');

    final existingIds = await sheet!.values.column(3);
    return existingIds.contains(regNo);
  }

  Future<void> addAttendee(String name, String email, String regNo) async {
    final ss = await _gsheets.spreadsheet(dotenv.env['SPREADSHEET_ID'] ?? '');
    final sheet = ss.worksheetByTitle('Sheet1');

    final existingIds = await sheet!.values.column(3);
    if (existingIds.contains(regNo)) {
      throw Exception(dotenv.env['ID_ALREADY_EXISTS'] ?? 'ID already exists');
    }

    final currentTime = DateTime.now().toLocal().toString();
    final rowData = [name, email, regNo, currentTime];

    await sheet.values.appendRow(rowData);
  }
}
