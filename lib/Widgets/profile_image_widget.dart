import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? base64Image;

  ProfileImageWidget({this.base64Image});

  @override
  Widget build(BuildContext context) {
    if (base64Image == null || base64Image!.isEmpty) {
      return CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/default_avatar.png'));
    }

    Uint8List imageBytes = base64Decode(base64Image!);
    return CircleAvatar(radius: 50, backgroundImage: MemoryImage(imageBytes));
  }
}
