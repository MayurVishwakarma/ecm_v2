// ignore_for_file: strict_top_level_inference

import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageProcessingInput {
  final Uint8List byteData;
  final String watermarkText;

  ImageProcessingInput(this.byteData, this.watermarkText);
}

Uint8List imageProcessingIsolate(ImageProcessingInput input) {
  final original = img.decodeImage(input.byteData);
  if (original == null) throw Exception("Failed to decode image");

  // 📏 Resize: max 800px on longer side
  int width = original.width;
  int height = original.height;
  const maxDimension = 800;

  if (width > height) {
    width = maxDimension;
    height = (original.height / original.width * maxDimension).round();
  } else {
    height = maxDimension;
    width = (original.width / original.height * maxDimension).round();
  }

  img.Image resized = img.copyResize(original, width: width, height: height);

  // ✍️ Add text watermark
  img.drawString(resized, input.watermarkText, font: img.arial14, x: 20, y: 30);

  // 🗜️ Compress with decreasing quality
  for (int quality = 90; quality >= 30; quality -= 10) {
    Uint8List compressed = Uint8List.fromList(
      img.encodeJpg(resized, quality: quality),
    );
    if (compressed.lengthInBytes <= 200 * 1024) {
      return compressed;
    }
  }

  // 🪓 Final fallback (still resized + watermarked but might be >200KB)
  return Uint8List.fromList(img.encodeJpg(resized, quality: 30));
}

Future<void> storeImagePath(XFile file) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('imagePath', file.path);
}

// Retrieve XFile path from SharedPreferences
Future<XFile?> retrieveImagePath() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? imagePath = prefs.getString('imagePath');
  if (imagePath != null) {
    return XFile(imagePath);
  }
  return null;
}

//we can upload image from camera or from gallery based on parameter
Future<bool> storeImagesInSharedPref(
  String imagePath,
  String checkListId,
) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setString(checkListId, imagePath);
}

Future<void> clearImageFromSharedPreferences(checkListId) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(checkListId);
}

Future<XFile> getPrefImage(checkListId) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var imagePath1 = pref.getString(checkListId.toString());
  return XFile(imagePath1 ?? '');
}
