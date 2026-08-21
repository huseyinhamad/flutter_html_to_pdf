// ignore_for_file: constant_identifier_names

/// Text direction for the PDF document
enum TextDirection {
  /// Left-to-Right (default for most languages)
  LTR,

  /// Right-to-Left (for Arabic, Hebrew, Persian, Urdu, etc.)
  RTL,
}

extension TextDirectionExt on TextDirection {
  /// Returns the CSS direction value
  String get directionKey {
    switch (this) {
      case TextDirection.LTR:
        return "ltr";
      case TextDirection.RTL:
        return "rtl";
    }
  }
}

/// Custom size class for defining custom document dimensions in pixels (72 PPI)
class CustomSize {
  final int width;
  final int height;

  /// Create a custom size with width and height in pixels (72 PPI)
  const CustomSize({
    required this.width,
    required this.height,
  });
}

/// Global variable to store custom size
CustomSize? _customSize;

/// Set a custom size for PrintSize.Custom
void setCustomSize(CustomSize size) {
  _customSize = size;
}

enum PrintSize {
  A0,
  A1,
  A2,
  A3,
  A4,
  A5,
  A6,
  A7,
  A8,
  A9,
  A10,
  Custom,
}

extension PrintSizeExt on PrintSize {
  /// Returns the printing pixel dimensions for `72 PPI`
  List<int> get getDimensionsInPixels {
    switch (this) {
      case PrintSize.A0:
        return [2384, 3370];
      case PrintSize.A1:
        return [1684, 2384];
      case PrintSize.A2:
        return [1191, 1684];
      case PrintSize.A3:
        return [842, 1191];
      case PrintSize.A4:
        return [595, 842];
      case PrintSize.A5:
        return [420, 595];
      case PrintSize.A6:
        return [298, 420];
      case PrintSize.A7:
        return [210, 298];
      case PrintSize.A8:
        return [147, 210];
      case PrintSize.A9:
        return [105, 147];
      case PrintSize.A10:
        return [74, 105];
      case PrintSize.Custom:
        if (_customSize != null) {
          return [_customSize!.width, _customSize!.height];
        }
        // Default to A4 if no custom size is set
        return [595, 842];
    }
  }

  /// Returns Key for android implementation
  String get printSizeKey {
    switch (this) {
      case PrintSize.A0:
        return "A0";
      case PrintSize.A1:
        return "A1";
      case PrintSize.A2:
        return "A2";
      case PrintSize.A3:
        return "A3";
      case PrintSize.A4:
        return "A4";
      case PrintSize.A5:
        return "A5";
      case PrintSize.A6:
        return "A6";
      case PrintSize.A7:
        return "A7";
      case PrintSize.A8:
        return "A8";
      case PrintSize.A9:
        return "A9";
      case PrintSize.A10:
        return "A10";
      case PrintSize.Custom:
        return "CUSTOM";
    }
  }
}

enum PrintOrientation {
  Portrait,
  Landscape,
}

extension PrintOrientationExt on PrintOrientation {
  /// Returns the index for getting width of print frame from array of
  int get getWidthDimensionIndex {
    switch (this) {
      case PrintOrientation.Landscape:
        return 1;
      case PrintOrientation.Portrait:
        return 0;
    }
  }

  /// Returns the index for getting height of print frame from array of
  int get getHeightDimensionIndex {
    switch (this) {
      case PrintOrientation.Landscape:
        return 0;
      case PrintOrientation.Portrait:
        return 1;
    }
  }

  /// Returns Key for android implementation
  String get orientationKey {
    switch (this) {
      case PrintOrientation.Landscape:
        return "LANDSCAPE";
      case PrintOrientation.Portrait:
        return "PORTRAIT";
    }
  }
}
