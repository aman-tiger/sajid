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
      RenderBox? box = context.findRenderObject() as RenderBox?;
      box ??= Overlay.maybeOf(context)?.context.findRenderObject() as RenderBox?;

      final shareOrigin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 0, 1, 1);

      final result = await Share.share(
        text,
        subject: subject,
        sharePositionOrigin: shareOrigin,
      );
      return result.status != ShareResultStatus.unavailable;
    } catch (_) {
      return false;
    }
  }
}
