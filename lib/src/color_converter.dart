import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorOrNullConverter implements JsonConverter<Color?, String?> {
  const ColorOrNullConverter();

  @override
  Color? fromJson(String? json) {
    if (json == null || json.isEmpty) {
      return null;
    }

    final buffer = StringBuffer();
    if (json.length == 6 || json.length == 7) {
      buffer.write('ff');
    }
    buffer.write(json.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  String? toJson(Color? object) {
    if (object == null) {
      return null;
    }

    return '#'
        '${object.red.toRadixString(16).padLeft(2, '0')}'
        '${object.green.toRadixString(16).padLeft(2, '0')}'
        '${object.blue.toRadixString(16).padLeft(2, '0')}';
  }
}
