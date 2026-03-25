class EncryptionService {
  static String encrypt(String plainText) {
    // Simple encoding for web compatibility
    return plainText.split('').map((c) => c.codeUnitAt(0).toString().padLeft(3, '0')).join();
  }

  static String decrypt(String encodedText) {
    try {
      if (encodedText.length % 3 != 0) return encodedText;
      List<String> result = [];
      for (int i = 0; i < encodedText.length; i += 3) {
        String code = encodedText.substring(i, i + 3);
        result.add(String.fromCharCode(int.parse(code)));
      }
      return result.join();
    } catch (_) {
      return encodedText;
    }
  }
}