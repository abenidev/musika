import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

Future<File?> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(type: FileType.image);
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
