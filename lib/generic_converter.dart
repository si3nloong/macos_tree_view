import 'package:json_annotation/json_annotation.dart';

class GenericConverter<T> implements JsonConverter<T, Object?> {
  const GenericConverter();

  @override
  T fromJson(Object? json) => json as T;

  @override
  Object? toJson(T object) {
    if (object == null) {
      return null;
    }

    return '$object';
  }
}
