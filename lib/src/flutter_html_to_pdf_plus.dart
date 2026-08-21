import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'file_utils.dart';
import 'pdf_print_configuration.dart';
import 'print_config_enums.dart';

/// HTML to PDF Converter
class FlutterHtmlToPdf {
  static const MethodChannel _channel =
      MethodChannel('flutter_html_to_pdf_plus');

  /// Creates PDF Document from HTML content
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<File> convertFromHtmlContent({
    required String content,
    required PrintPdfConfiguration configuration,
  }) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String tempHtmlFileName =
        'flutter_html_to_pdf_${DateTime.now().millisecondsSinceEpoch}.html';
    final File temporaryCreatedHtmlFile =
        File('${tempDir.path}/$tempHtmlFileName');

    await FileUtils.createFileWithStringContent(
      content,
      temporaryCreatedHtmlFile.path,
    );
    await FileUtils.appendStyleTagToHtmlFile(
      temporaryCreatedHtmlFile.path,
      textDirection: configuration.textDirection,
    );

    final String generatedPdfFilePath = await _convertFromHtmlFilePath(
      temporaryCreatedHtmlFile.path,
      configuration,
    );

    // Ensure the temporary HTML file is deleted even if errors occur later
    try {
      if (await temporaryCreatedHtmlFile.exists()) {
        await temporaryCreatedHtmlFile.delete();
      }
    } catch (e) {
      // Ignored
    }

    return FileUtils.copyAndDeleteOriginalFile(
      generatedPdfFilePath,
      configuration.targetDirectory,
      configuration.targetName,
    );
  }

  /// Creates PDF Document from HTML content and returns [Uint8List]
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<Uint8List> convertFromHtmlContentBytes({
    required String content,
    required PrintPdfConfiguration configuration,
  }) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String tempHtmlFileName =
        'flutter_html_to_pdf_${DateTime.now().millisecondsSinceEpoch}.html';
    final File temporaryCreatedHtmlFile =
        File('${tempDir.path}/$tempHtmlFileName');

    await FileUtils.createFileWithStringContent(
      content,
      temporaryCreatedHtmlFile.path,
    );
    await FileUtils.appendStyleTagToHtmlFile(
      temporaryCreatedHtmlFile.path,
      textDirection: configuration.textDirection,
    );

    final String generatedPdfFilePath = await _convertFromHtmlFilePath(
      temporaryCreatedHtmlFile.path,
      configuration,
    );

    // Ensure the temporary HTML file is deleted even if errors occur later
    try {
      if (await temporaryCreatedHtmlFile.exists()) {
        await temporaryCreatedHtmlFile.delete();
      }
    } catch (e) {
      // Ignored
    }

    return FileUtils.readAndDeleteOriginalFile(generatedPdfFilePath);
  }

  /// Creates PDF Document from File that contains HTML content
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<File> convertFromHtmlFile({
    required File htmlFile,
    required PrintPdfConfiguration configuration,
  }) async {
    await FileUtils.appendStyleTagToHtmlFile(
      htmlFile.path,
      textDirection: configuration.textDirection,
    );
    final String generatedPdfFilePath = await _convertFromHtmlFilePath(
      htmlFile.path,
      configuration,
    );

    return FileUtils.copyAndDeleteOriginalFile(
      generatedPdfFilePath,
      configuration.targetDirectory,
      configuration.targetName,
    );
  }

  /// Creates PDF Document from File that contains HTML content and returns [Uint8List]
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<Uint8List> convertFromHtmlFileBytes({
    required File htmlFile,
    required PrintPdfConfiguration configuration,
  }) async {
    await FileUtils.appendStyleTagToHtmlFile(
      htmlFile.path,
      textDirection: configuration.textDirection,
    );
    final String generatedPdfFilePath = await _convertFromHtmlFilePath(
      htmlFile.path,
      configuration,
    );

    return FileUtils.readAndDeleteOriginalFile(generatedPdfFilePath);
  }

  /// Creates PDF Document from path to File that contains HTML content
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<File> convertFromHtmlFilePath({
    required String htmlFilePath,
    required PrintPdfConfiguration configuration,
  }) async {
    await FileUtils.appendStyleTagToHtmlFile(
      htmlFilePath,
      textDirection: configuration.textDirection,
    );
    final String generatedPdfFilePath = await _convertFromHtmlFilePath(
      htmlFilePath,
      configuration,
    );

    return FileUtils.copyAndDeleteOriginalFile(
      generatedPdfFilePath,
      configuration.targetDirectory,
      configuration.targetName,
    );
  }

  /// Creates PDF Document from path to File that contains HTML content and returns [Uint8List]
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<Uint8List> convertFromHtmlFilePathBytes({
    required String htmlFilePath,
    required PrintPdfConfiguration configuration,
  }) async {
    await FileUtils.appendStyleTagToHtmlFile(
      htmlFilePath,
      textDirection: configuration.textDirection,
    );
    final String generatedPdfFilePath = await _convertFromHtmlFilePath(
      htmlFilePath,
      configuration,
    );

    return FileUtils.readAndDeleteOriginalFile(generatedPdfFilePath);
  }

  /// Assumes the invokeMethod call will return successfully
  static Future<String> _convertFromHtmlFilePath(
    String htmlFilePath,
    PrintPdfConfiguration configuration,
  ) async {
    int width;
    int height;

    if (configuration.printSize == PrintSize.Custom &&
        configuration.customSize != null) {
      width = configuration.customSize!.width;
      height = configuration.customSize!.height;
      if (configuration.printOrientation == PrintOrientation.Landscape &&
          width < height) {
        final temp = width;
        width = height;
        height = temp;
      } else if (configuration.printOrientation == PrintOrientation.Portrait &&
          width > height) {
        final temp = width;
        width = height;
        height = temp;
      }
    } else {
      width = configuration.printSize.getDimensionsInPixels[
          configuration.printOrientation.getWidthDimensionIndex];
      height = configuration.printSize.getDimensionsInPixels[
          configuration.printOrientation.getHeightDimensionIndex];
    }

    // Create the parameters map
    final Map<String, dynamic> params = {
      'htmlFilePath': htmlFilePath,
      'width': width,
      'height': height,
      'printSize': configuration.printSize.printSizeKey,
      'orientation': configuration.printOrientation.orientationKey,
      'margins': [
        configuration.margins.left,
        configuration.margins.top,
        configuration.margins.right,
        configuration.margins.bottom,
      ],
    };

    return await _channel.invokeMethod(
      'convertHtmlToPdf',
      params,
    ) as String;
  }
}
