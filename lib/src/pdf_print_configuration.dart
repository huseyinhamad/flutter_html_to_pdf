import 'print_config_enums.dart';

class PdfPageMargin {
  final int top;
  final int bottom;
  final int left;
  final int right;

  const PdfPageMargin({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });
}

/// Print Pdf Configuration
class PrintPdfConfiguration {
  final String targetDirectory;
  final String targetName;
  final PdfPageMargin margins;
  final PrintSize printSize;
  final PrintOrientation printOrientation;
  final CustomSize? customSize;
  final TextDirection textDirection;

  /// `targetDirectory` is the desired path for the Pdf file.
  ///
  /// `targetName` is the name of the Pdf file
  ///
  /// `margins` is the page margin of the Pdf file
  ///
  /// `printSize` is the print size of the Pdf file
  ///
  /// `printOrientation` is the print orientation of the Pdf file
  ///
  /// `customSize` is the custom size for the Pdf file (only used when printSize is PrintSize.Custom)
  ///
  /// `textDirection` is the text direction of the Pdf file (LTR or RTL)
  PrintPdfConfiguration({
    required this.targetDirectory,
    required this.targetName,
    this.margins =
        const PdfPageMargin(top: 50, bottom: 50, left: 50, right: 50),
    this.printSize = PrintSize.A4,
    this.printOrientation = PrintOrientation.Portrait,
    this.customSize,
    this.textDirection = TextDirection.LTR,
  });

  /// Returns the final path for temporary Html File
  String get htmlFilePath => "$targetDirectory/$targetName.html";
}
