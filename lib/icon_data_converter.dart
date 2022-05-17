import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

class IconDataOrNullConverter implements JsonConverter<IconData?, dynamic> {
  const IconDataOrNullConverter();

  @override
  IconData? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }

    if (json is! int) {
      return null;
    }

    return IconData(json);
  }

  @override
  dynamic toJson(IconData? object) {
    if (object == null) {
      return null;
    }

    return object.codePoint;
  }
}
