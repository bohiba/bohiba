import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  // ✅ Generate a 32-character key (AES-256)
  // b0h!ba!#3ncRyPT
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  // static final _iv = encrypt.IV.fromLength(16);

  static String encryptText(String plainText) {
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return "${iv.base64}:${encrypted.base64}";
  }

  static String decryptText(String encryptedText) {
    final parts = encryptedText.split(':');
    if (parts.length != 2) throw ArgumentError('Invalid encrypted format');
    final iv = encrypt.IV.fromLength(16);
    final cipher = parts[1];
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));

    return encrypter.decrypt64(cipher, iv: iv);
  }
}
