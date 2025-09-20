// import 'dart:io';
import '/services/global_service.dart';
// import 'package:image/image.dart' as img;
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  /*static final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  static Future<String> getTextFromImage(String imagePath) async {
    try {
      final String lightingStatus = await compute(_checkLighting, imagePath);
      if (lightingStatus != "Lighting looks good.") {
        return "⚠️ $lightingStatus Please retake the photo.";
      }

      InputImage inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText result =
          await _textRecognizer.processImage(inputImage);

      if (result.blocks.isEmpty) return 'Invalid photo of document';

      final buffer = StringBuffer();
      for (TextBlock block in result.blocks) {
        buffer.writeln(block.text);
      }
      return buffer.toString().trim();
    } catch (e) {
      return 'OCR Error: $e';
    }
  }*/

  /*static String _checkLighting(String imagePath) {
    final bytes = File(imagePath).readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image == null) return "Image not readable.";

    final img.Image gray = img.grayscale(image);

    int totalBrightness = 0;
    for (int y = 0; y < gray.height; y++) {
      for (int x = 0; x < gray.width; x++) {
        final pixel = gray.getPixel(x, y);
        totalBrightness += img.getLuminance(pixel).toInt();
      }
    }

    double avgBrightness = totalBrightness / (gray.width * gray.height);

    if (avgBrightness < 60) {
      return "Too dark — increase lighting.";
    } else {
      return "Lighting looks good.";
    }
  }*/

  static Future<void> dispose() async {
    GlobalService.printHandler('OCR: Disposed Successfully');
    // await _textRecognizer.close();
  }
}
