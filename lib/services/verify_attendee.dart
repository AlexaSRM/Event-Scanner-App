class VerifyAttendee {

  static String _keyword = "MySecretKeyword";

  static String decryptData(String encryptedData) {
    String decryptedData = '';
    for (int i = 0; i < encryptedData.length; i++) {
      int decryptedCharCode =
          encryptedData.codeUnitAt(i) - _keyword.codeUnitAt(i % _keyword.length);

      if (decryptedCharCode >= 0 && decryptedCharCode <= 1114111) {
        decryptedData += String.fromCharCode(decryptedCharCode);
      } else {
        decryptedData += '?';
      }
    }
    return decryptedData;
  }
}
