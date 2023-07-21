import 'package:flutter/material.dart';
import 'package:event_scanner/presentation/screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(), // Set QRScannerPage as the home page
    );
  }
}
