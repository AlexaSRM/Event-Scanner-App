import 'dart:convert';
import 'package:flutter/material.dart';

class VerifyAttendee {
  // Replace "MySecretKeyword" with your actual secret keyword used for encryption.
  static String _keyword = "MySecretKeyword";

  static String decryptData(String encryptedData) {
    String decryptedData = '';
    for (int i = 0; i < encryptedData.length; i++) {
      int decryptedCharCode =
          encryptedData.codeUnitAt(i) - _keyword.codeUnitAt(i % _keyword.length);
      decryptedData += String.fromCharCode(decryptedCharCode);
    }
    return decryptedData;
  }


}
