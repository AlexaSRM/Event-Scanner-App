import 'package:flutter/material.dart';
import 'package:event_scanner/presentation/screens/home_page.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';


Future<void> main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
