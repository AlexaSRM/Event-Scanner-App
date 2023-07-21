import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../services/gsheets.dart';
import '../../services/verify_attendee.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool attendeeAdded = false; // Flag to track if an attendee has been added
  bool scanning = false; // Flag to track if scanning is in progress
  Timer? qrScanTimer; // Timer for QR scanning

  @override
  void initState() {
    super.initState();
    attendeeAdded = false; // Initialize the flag to false

    // 1000ms 1 fps
    qrScanTimer = Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      // Set scanning flag to false to allow the next scan
      scanning = false;
    });
  }

  @override
  void dispose() {
    qrScanTimer?.cancel(); // Cancel the QR scanning timer
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: result != null
                  ? Text(
                'Data: ${result!.code}',
              )
                  : const Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (scanning) return; // Ignore the scan if already scanning
      setState(() async {
        scanning = true; // Set scanning flag to true to prevent multiple scans
        result = scanData;
        if (result != null) {
          String? encryptedData = result!.code;
          List<String> qrData = encryptedData!.split(',');

          if (qrData.length >= 2) {
            String expectedRegNo = qrData[1].trim();
            String encryptedRegNo = qrData[qrData.length - 1].trim();
            String decryptedRegNo = VerifyAttendee.decryptData(encryptedRegNo);

            if (!attendeeAdded && decryptedRegNo == expectedRegNo) {
              // Add the attendee data to Google Sheets
              try {
                final gsheetsService = GSheetsService();
                final attendeeExists = await gsheetsService.checkAttendeeExists(decryptedRegNo);

                if (!attendeeExists) {
                  await gsheetsService.addAttendee(qrData[0], qrData[2], decryptedRegNo);
                  attendeeAdded = true; // Set the flag to true after adding attendee
                  _showSuccessSnackBar(); // Show a success SnackBar
                } else {
                  _showErrorSnackBar('Attendee Already Added');
                }
              } catch (e) {
                _showErrorSnackBar('Error adding attendee: $e');
              }
            } else if (attendeeAdded && decryptedRegNo == expectedRegNo) {
              _showErrorSnackBar('Attendee Already Added');
            } else {
              _showErrorSnackBar('Trespasser');
            }
          }
        }
      });
    });
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Attendee Added'),
        backgroundColor: Colors.green, // Customize the color here
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red, // Customize the color here
      ),
    );
  }
}
