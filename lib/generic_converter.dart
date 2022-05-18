import 'package:freezed_annotation/freezed_annotation.dart';

class GenericConverter<T> implements JsonConverter<T, Object> {
  const GenericConverter();

  @override
  T fromJson(Object json) => json as T;

  @override
  Object toJson(T object) => object as Object;
}
