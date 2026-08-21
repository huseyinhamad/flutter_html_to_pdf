import 'dart:io';
import 'dart:typed_data';

import 'print_config_enums.dart';

class FileUtils {
  static Future<File> createFileWithStringContent(
      String content, String path) async {
    return await File(path).writeAsString(content);
  }

  static File copyAndDeleteOriginalFile(
      String generatedFilePath, String targetDirectory, String targetName) {
    final fileOriginal = File(generatedFilePath);
    final fileCopy = File('$targetDirectory/$targetName.pdf');
    fileCopy.writeAsBytesSync(File.fromUri(fileOriginal.uri).readAsBytesSync());
    fileOriginal.delete();
    return fileCopy;
  }

  static Uint8List readAndDeleteOriginalFile(String generatedFilePath) {
    final fileOriginal = File(generatedFilePath);
    final bytes = File.fromUri(fileOriginal.uri).readAsBytesSync();
    fileOriginal.delete().ignore();
    return bytes;
  }

  static Future<void> appendStyleTagToHtmlFile(
    String htmlPath, {
    TextDirection textDirection = TextDirection.LTR,
  }) async {
    String printStyleHtml = """
      <style>
        @media print {
          * {
            -webkit-print-color-adjust: exact !important;
          }
        }
        html, body {
          direction: ${textDirection.directionKey};
        }
      </style>
    """;
    await File(htmlPath).writeAsString(printStyleHtml, mode: FileMode.append);
  }
}
