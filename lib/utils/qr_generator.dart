import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> saveQRCode(String data) async {
  try {
    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print("Storage permission denied");
      return;
    }

    // Generate QR Code as an image
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.error) {
      print("QR Code generation failed");
      return;
    }

    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      color: Colors.black,
      emptyColor: Colors.white,
    );

    // Save the image as PNG
    final directory = await getExternalStorageDirectory(); // Get storage directory
    final filePath = '${directory!.path}/qr_code.png';
    final file = File(filePath);

    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final size = const Size(300, 300);

    painter.paint(canvas, size);
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(300, 300);
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    await file.writeAsBytes(byteData!.buffer.asUint8List());

    print("QR Code saved at: $filePath");

    // Save to gallery
    await GallerySaver.saveImage(filePath);
    print("QR Code saved to gallery!");

  } catch (e) {
    print("Error saving QR Code: $e");
  }
}
