import 'dart:io';

Future<void> deleteImage(String path) async {
  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }
}
