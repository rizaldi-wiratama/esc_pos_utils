/*
 * esc_pos_utils
 * Created by Andrey U.
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

enum PosAlign { left, center, right }
enum PosCutMode { full, partial }
enum PosFontType { fontA, fontB }
enum PosDrawer { pin2, pin5 }

/// Choose image printing function
/// bitImageRaster: GS v 0 (obsolete)
/// graphics: GS ( L
enum PosImageFn { bitImageRaster, graphics }

class PosTextSize {
  const PosTextSize._internal(this.value);
  final double value;
  static const sizeSmall = PosTextSize._internal(1);
  static const sizeMedium = PosTextSize._internal(1.5);
  static const sizeLarge = PosTextSize._internal(2);
  static const size3 = PosTextSize._internal(3);
  static const size4 = PosTextSize._internal(4);
  static const size5 = PosTextSize._internal(5);
  static const size6 = PosTextSize._internal(6);
  static const size7 = PosTextSize._internal(7);
  static const size8 = PosTextSize._internal(8);

  ///Decimal number based on this reference https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=34
  static int decSize(PosTextSize height, PosTextSize width) {
    ///For medium size we agree to use 2x height and 1x width, so based on reference
    ///the decimal number of 1x width = 0
    ///the decimal number of 2x height = 1
    ///so the decimal number is 0 + 1 = 1
    if(width.value == 1.5) return 1;

    ///For small size (1x width & 1x height) : 16 * (1-1) + (1-1) = 16 * 0 + 0 = 0
    ///For large size (2x width & 2x height) : 16 * (2-1) + (2-1) = 16 * 1 + 1 = 17
    ///
    ///why 17 for large size? because based on reference
    ///the decimal number of 2x width = 16
    ///the decimal number of 2x height = 1
    ///so the decimal number is 16 + 1 = 17
    return (16 * (width.value - 1) + (height.value - 1)).ceil();
  }
}

class PaperSize {
  const PaperSize._internal(this.value);
  final int value;
  static const mm58 = PaperSize._internal(1);
  static const mm80 = PaperSize._internal(2);

  int get width => value == PaperSize.mm58.value ? 372 : 558;
}

class PosBeepDuration {
  const PosBeepDuration._internal(this.value);
  final int value;
  static const beep50ms = PosBeepDuration._internal(1);
  static const beep100ms = PosBeepDuration._internal(2);
  static const beep150ms = PosBeepDuration._internal(3);
  static const beep200ms = PosBeepDuration._internal(4);
  static const beep250ms = PosBeepDuration._internal(5);
  static const beep300ms = PosBeepDuration._internal(6);
  static const beep350ms = PosBeepDuration._internal(7);
  static const beep400ms = PosBeepDuration._internal(8);
  static const beep450ms = PosBeepDuration._internal(9);
}
