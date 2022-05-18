import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

class KeyOrNullConverter implements JsonConverter<Key, String> {
  const KeyOrNullConverter();

  @override
  Key fromJson(String json) {
    return Key(json);
  }

  @override
  String toJson(Key object) {
    if (object is ValueKey) {
      return '${object.value}';
    }

    return object.toString();
  }
}
