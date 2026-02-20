import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  ShareService._();

  static Future<bool> shareText(
    BuildContext context,
    String text, {
    String? subject,
  }) async {
    try {
      final box = context.findRenderObject();
      final shareOrigin = box is RenderBox
          ? box.localToGlobal(Offset.zero) & box.size
          : null;

      await Share.share(
        text,
        subject: subject,
        sharePositionOrigin: shareOrigin,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
