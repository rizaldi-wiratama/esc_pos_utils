/*
 * esc_pos_utils
 * Created by Andrey U.
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:esc_pos_utils/src/commands.dart';
import 'dart:convert';

class QRSize {
  const QRSize(this.value);
  final int value;

  static const Size1 = QRSize(0x01);
  static const Size2 = QRSize(0x02);
  static const Size3 = QRSize(0x03);
  static const Size4 = QRSize(0x04);
  static const Size5 = QRSize(0x05);
  static const Size6 = QRSize(0x06);
  static const Size7 = QRSize(0x07);
  static const Size8 = QRSize(0x08);
}

/// QR Correction level
class QRCorrection {
  const QRCorrection._internal(this.value);
  final int value;

  /// Level L: Recovery Capacity 7%
  static const L = QRCorrection._internal(48);

  /// Level M: Recovery Capacity 15%
  static const M = QRCorrection._internal(49);

  /// Level Q: Recovery Capacity 25%
  static const Q = QRCorrection._internal(50);

  /// Level H: Recovery Capacity 30%
  static const H = QRCorrection._internal(51);
}

class QRCode {
  List<int> bytes = <int>[];

  QRCode(String text, QRSize size, QRCorrection level) {
    // FN 167. QR Code: Set the size of module
    // pL pH cn fn n
    bytes += cQrHeader.codeUnits + [0x03, 0x00, 0x31, 0x43] + [size.value];

    // FN 169. QR Code: Select the error correction level
    // pL pH cn fn n
    bytes += cQrHeader.codeUnits + [0x03, 0x00, 0x31, 0x45] + [level.value];

    // FN 180. QR Code: Store the data in the symbol storage area
    List<int> textBytes = latin1.encode(text);
    // pL pH cn fn m

    // Calculate pL and pH based on text length. In 80mm printer, QR can contains data with more than 256 characters
    // Reference:
    // https://download4.epson.biz/sec_pubs/pos/reference_en/escpos/gs_lparen_lk_fn180.html
    // https://github.com/NielsLeenheer/EscPosEncoder/issues/6#issuecomment-411496158
    // https://github.com/qzind/tray/issues/484#issuecomment-528596676
    int storeLength = textBytes.length + 3;
    var lsb = storeLength % 256;
    var msb = (storeLength / 256).floor();

    bytes += cQrHeader.codeUnits + [lsb, msb, 0x31, 0x50, 0x30];
    bytes += textBytes;

    // FN 182. QR Code: Transmit the size information of the symbol data in the symbol storage area
    // pL pH cn fn m
    bytes += cQrHeader.codeUnits + [0x03, 0x00, 0x31, 0x52, 0x30];

    // FN 181. QR Code: Print the symbol data in the symbol storage area
    // pL pH cn fn m
    bytes += cQrHeader.codeUnits + [0x03, 0x00, 0x31, 0x51, 0x30];
  }
}
