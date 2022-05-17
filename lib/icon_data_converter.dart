import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

class IconDataOrNullConverter implements JsonConverter<IconData?, int?> {
  const IconDataOrNullConverter();

  @override
  IconData? fromJson(int? json) {
    if (json == null) {
      return null;
    }

    return IconData(json);
  }

  @override
  int? toJson(IconData? object) {
    if (object == null) {
      return null;
    }

    return object.codePoint;
  }
}
