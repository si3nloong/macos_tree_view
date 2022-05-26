import 'package:freezed_annotation/freezed_annotation.dart';

// import 'node.dart';

/// This JsonConverter class holds the toJson/fromJson logic for generic type
/// fields in our Object that will be de/serialized.
/// This keeps our Object class clean, separating out the converter logic.
///
/// JsonConverter takes two type variables: <T,S>.
///
/// Inside our JsonConverter, T and S are used like so:
///
/// T fromJson(S)
/// S toJson(T)
///
/// T is the concrete class type we're expecting out of fromJson() calls.
/// It's also the concrete type we're inputting for serialization in toJson() calls.
///
/// Most commonly, T will just be T: a variable type passed to JsonConverter in our
/// Object being serialized, e.g. the "T" from OperationResult<T> above.
///
/// S is the JSON type.  Most commonly this would Map<String,dynamic>
/// if we're only de/serializing single objects.  But, if we want to de/serialize
/// Lists, we need to use "Object" instead to handle both a single object OR a List of objects.
class NodeConverter<T> implements JsonConverter<T, Object> {
  const NodeConverter();

  /// fromJson takes Object instead of Map<String,dynamic> so as to handle both
  /// a JSON map or a List of JSON maps.  If List is not used, you could specify
  /// Map<String,dynamic> as the S type variable and use it as
  /// the json argument type for fromJson() & return type of toJson().
  /// S can be any Dart supported JSON type
  /// https://pub.dev/packages/json_serializable/versions/6.0.0#supported-types
  /// In this example we only care about Object and List<Object> serialization
  @override
  T fromJson(Object json) {
    /// start by checking if json is just a single JSON map, not a List
    // if (json is Map<String, dynamic>) {
    //   /// now do our custom "inspection" of the JSON map, looking at key names
    //   /// to figure out the type of T t. The keys in our JSON will
    //   /// correspond to fields of the object that was serialized.
    //   return Node.fromJson(json) as T;
    // } else if (json is List) {
    //   /// here we handle Lists of JSON maps
    //   if (json.isEmpty) {
    //     return [] as T;
    //   }

    //   return json.map((v) => Node.fromJson(v as Map<String, dynamic>)).toList()
    //       as T;
    // }

    /// We didn't recognize this JSON map as one of our model classes, throw an error
    /// so we can add the missing case
    throw ArgumentError.value(
        json,
        'json',
        'OperationResult._fromJson cannot handle'
            ' this JSON payload. Please add a handler to _fromJson.');
  }

  /// Since we want to handle both JSON and List of JSON in our toJson(),
  /// our output Type will be Object.
  /// Otherwise, Map<String,dynamic> would be OK as our S type / return type.
  ///
  /// Below, "Serializable" is an abstract class / interface we created to allow
  /// us to check if a concrete class of type T has a "toJson()" method. See
  /// next section further below for the definition of Serializable.
  /// Maybe there's a better way to do this?
  ///
  /// Our JsonConverter uses a type variable of T, rather than "T extends Serializable",
  /// since if T is a List, it won't have a toJson() method and it's not a class
  /// under our control.
  /// Thus, we impose no narrower scope so as to handle both cases: an object that
  /// has a toJson() method, or a List of such objects.
  @override
  Object toJson(T object) {
    /// First we'll check if object is Serializable.
    /// Nodeing for Serializable type (our custom interface of a class signature
    /// that has a toJson() method) allows us to call toJson() directly on it.
    if (object is JsonSerializable) {
      return object.toJson();
    }

    /// otherwise, check if it's a List & not empty & elements are Serializable
    else if (object is List) {
      if (object.isEmpty) return [];

      if (object.first is JsonSerializable) {
        return object.map((t) => t.toJson()).toList();
      }
    }

    /// It's not a List & it's not Serializable, this is a design issue
    throw ArgumentError.value(
        object,
        'Cannot serialize to JSON',
        'Node._toJson this object or List either is not '
            'Serializable or is unrecognized.');
  }
}
