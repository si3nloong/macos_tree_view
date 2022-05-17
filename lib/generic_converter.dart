import 'package:freezed_annotation/freezed_annotation.dart';

class GenericConverter<T> implements JsonConverter<T, Map<String, dynamic>> {
  const GenericConverter();

  @override
  T fromJson(Map<String, dynamic> json) {
    // type data was already set (e.g. because we serialized it ourselves)
    return json as T;
  }

  @override
  Map<String, dynamic> toJson(T object) => object as Map<String, dynamic>;
}
