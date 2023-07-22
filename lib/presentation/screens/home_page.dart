import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../services/gsheets.dart';
import '../../services/verify_attendee.dart';
import '../../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scanning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'assets/images/alexa_logo.svg',
            width: 32,
            height: 32,
          ),
        ),
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: result != null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Name: ${getName(result?.code)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Reg. No.: ${getEmail(result?.code)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
                    : const Text(Constants.scanQRMessage),
              ),
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
      if (scanning) return;

      // Pause the camera
      controller.pauseCamera();

      setState(() {
        scanning = true;
        result = scanData;
      });

      if (result != null) {
        String? encryptedData = result!.code;
        List<String> qrData = encryptedData!.split(',');

        if (qrData.length >= 3) {
          String expectedRegNo = qrData[1].trim();
          String encryptedRegNo = qrData[qrData.length - 1].trim();
          String decryptedRegNo = VerifyAttendee.decryptData(encryptedRegNo);

          if (expectedRegNo != decryptedRegNo) {
            _showErrorSnackBar(Constants.duplicateAttendeeMessage);
          } else {
            try {
              final gsheetsService = GSheetsService();
              final attendeeExists =
              await gsheetsService.checkAttendeeExists(decryptedRegNo);

              if (!attendeeExists) {
                await gsheetsService.addAttendee(
                    qrData[0], qrData[2], decryptedRegNo);
                _showSuccessSnackBar();
              } else {
                _showErrorSnackBar(Constants.attendeeAddedMessage);
              }
            } catch (e) {
              _showErrorSnackBar('Error adding attendee: $e');
            }
          }
        } else {
          _showErrorSnackBar(Constants.invalidQRCodeMessage);
        }
      }
    });
  }


  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(Constants.attendeeAddedMessage),
        backgroundColor: Colors.green,
      ),
    );
    _resumeCamera();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
    _resumeCamera();
  }

  void _resumeCamera() {
    if (controller != null && scanning) {
      controller!.resumeCamera();
      scanning = false;
    }
  }

  // Helper methods to extract data from QR code

  String getName(String? qrCode) {
    List<String> qrData = qrCode?.split(',') ?? [];
    return qrData.isNotEmpty ? qrData[0].trim() : '';
  }

  String getEmail(String? qrCode) {
    List<String> qrData = qrCode?.split(',') ?? [];
    return qrData.length >= 2 ? qrData[1].trim() : '';
  }
}
