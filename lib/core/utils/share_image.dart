import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Renders the [RepaintBoundary] behind [boundaryKey] to a PNG and opens the
/// share sheet, so receipts go to WhatsApp as images like other bank apps.
Future<void> shareWidgetAsImage(
  GlobalKey boundaryKey, {
  required String fileName,
  Rect? sharePositionOrigin,
}) async {
  final boundary =
      boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 3);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$fileName.png');
  await file.writeAsBytes(bytes!.buffer.asUint8List(), flush: true);

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, mimeType: 'image/png')],
      // Required on iPad, where the share sheet is a popover.
      sharePositionOrigin: sharePositionOrigin,
    ),
  );
}
