import 'dart:async';
import 'package:gsheets/gsheets.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "fluttergsheets-392715",
  "private_key_id": "5a7a1fb8038870e9fd6c8ebbed548b8fc6c25bf4",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCqJ8475dIN2syB\nHRzngURnxiV+n/zOhE1yujUM3OL2GVQS9AeeKzssvVtCpWS8yWbGkEvVsMLjNha7\no0hrDeSpVtU5KDVGqFrX0mzClpAAthD6prcnP7mORYoDUeOgX6LxxV81UjEn/5Ma\n6KkZQKXH57JK228HA/og8ZFoxMBG323Re1Jx2Lg10Y6K8P8U3p2a722XCoORrIjp\nCPl0pVWDUjv2tuO8zSun0x+jEsPw3CuvUkUd26+iXdmPLZNOfAtN02/zPsE1PGgN\nN3T9TIRf9mMIQnjgUBWmk9ipUJD6fcx+e4ZmdHqwFIM/5Dj3GPMY5j7gqjP4ZPgp\nZ8CykhaBAgMBAAECggEAAPq2vDU1l7qIvo7GWGVX6w42v97b2jxqy1MiKDJTvxEV\nZCcPh0n4mRbkmFtfwbCjcUD4mUS8HR/iyr9sNk0to21NLJzGlsZA7XM9i+0L70YD\nZPE7Ea0bQ38f2qnmame1HJQkJcac3LrHsZFGNiLaedGCBXFj8l977kosQGNtXekN\nVI4Gv3vK3aWVGQccm8g0EI+uUHqkSA0CQF5VKP3fCAY0IWQIb0fSQu8A3KaNRsBd\n3HHG/A3ypZ/1kO6+t7vS+KzZSVwjpSfbwdJNpN/hOH9ADE/CNOnTvhwv7HqSHCOp\nQEwkpaNaBOtgag5d+o2Q1HKIp+U7rAqbyG7742c24QKBgQDi5XxX2HIoILyoTgA1\n5vyz2DfphA2F6Ulk1Ge7oDPvyqxXqt/XKQ2h8VpnsmwMF9Bc6VZCl8oV1hQvI8Rg\nb5Z6Rx5GSEaKzhm2V/j1xBEHrgZznqB4oftoc6BdSQmJE8GgadIno0pvUfBsPLDp\n+gNtnoyqrjRY22YUFcGLybEaYQKBgQC/+yN+cRxiWwL+mqAB7MBb8i9BN9CcdbOB\n0iObqlo2p3MYGHjpm5hzpfYTrD+gU0evBVizhGnnWuK4o5smHhuoWPzHw2SPMZ2N\nBs0JoPFpwBYN9BYRNlzzyi6KsMaycw/gSLPpC+BmKyD1NH5GLGVIDI1rPHuJUyzu\nTf7IxHuwIQKBgFRvGaqG/VQ5ensXK7TjVD6Iw6W+Ylnmyk0fTcrgfvNI9IFbMRkc\nSdptujrEhripU/x/SH5XhfhCRhiUsstAOzsdpAJ7euTEdYUJj7fFUqEM/ZGhAg5i\nGPBxtseAGnBMTc2oE3B0r4plb5aXry4iv4vXaHlLgmdencnznqaqU6GBAoGATACH\nT7JF02ZGbDcYq0pn6L6bGI2ZJ6etFfL0J9cr+cEW3m4pyAnSM856+dTSJ41wrohG\nUmNUbcPcR851SITY3C/GeusOr2WsAr2zhGFT0VK7KHD+H3hPGjBrdnp/XvwQR/Fg\nUB1ki+39ETXj27INspVNkyuRmI72Fa2I9UBb2yECgYEAzplCW1x/h1bCVWC+6lyX\nQWi5VDkSDBe6Yy/3nH3ClNzwNoArVy8F1MuFuWltEpI77ZIzIVkxz9GiJoFCr1rm\njHZgsFTeGtIAjWE2qdvILsuTo2HnwGCKmB8yJbyEYQ+gsWJhHv+vsPEA9zR/SKOT\n5rKSvTJf0clqU/KjPmwgFIc=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets-test@fluttergsheets-392715.iam.gserviceaccount.com",
  "client_id": "108578750708970023124",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets-test%40fluttergsheets-392715.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}''';

const _spreadsheetId = '1NTU3Mqv06xRvDGbEE_FPND9piBQQmq5sJ2W0YDOYWQA';

class GSheetsService {
  final GSheets _gsheets;

  GSheetsService() : _gsheets = GSheets(_credentials);

  Future<bool> checkAttendeeExists(String regNo) async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    final sheet = ss.worksheetByTitle('Sheet1');

    final existingIds = await sheet!.values.column(3);
    return existingIds.contains(regNo);
  }

  Future<void> addAttendee(String name, String email, String regNo) async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    final sheet = ss.worksheetByTitle('Sheet1');

    final existingIds = await sheet!.values.column(3);
    if (existingIds.contains(regNo)) {
      throw Exception('ID already exists in Google Sheets');
    }

    await Future.delayed(Duration(seconds: 3)); // 3-second pause
    final rowData = [name, email, regNo];
    await sheet.values.appendRow(rowData);
  }
}