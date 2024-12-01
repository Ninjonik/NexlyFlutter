import 'dart:typed_data';

import '../appwrite.dart';

Future<Uint8List?> getAvatar(String fileId) async {
  Uint8List filePreview = await storage.getFilePreview(
    bucketId: "avatars",
    fileId: fileId,
  );

  return filePreview;
}
