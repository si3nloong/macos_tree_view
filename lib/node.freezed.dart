// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Node<T> _$NodeFromJson<T>(Map<String, dynamic> json) {
  return _Node<T>.fromJson(json);
}

/// @nodoc
mixin _$Node<T> {
  /// The unique string that identifies this object.
  @KeyOrNullConverter()
  Key get key => throw _privateConstructorUsedError;

  /// The string value that is displayed on the [TreeNode].
  String get label => throw _privateConstructorUsedError;

  /// An optional icon that is displayed on the [TreeNode].
  @IconDataOrNullConverter()
  IconData? get icon => throw _privateConstructorUsedError;

  /// An optional color that will be applied to the icon for this node.
  @ColorOrNullConverter()
  Color? get iconColor => throw _privateConstructorUsedError;

  /// An optional color that will be applied to the icon when this node
  /// is selected.
  @ColorOrNullConverter()
  Color? get selectedIconColor => throw _privateConstructorUsedError;

  /// The open or closed state of the [TreeNode]. Applicable only if the
  /// node is a parent
  bool get expanded => throw _privateConstructorUsedError;

  /// Generic data model that can be assigned to the [TreeNode]. This makes
  /// it useful to assign and retrieve data associated with the [TreeNode]
  @GenericConverter()
  T? get data => throw _privateConstructorUsedError;

  /// The sub [Node]s of this object.
  @NodeConverter()
  List<Node<T>> get children => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NodeCopyWith<T, Node<T>> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeCopyWith<T, $Res> {
  factory $NodeCopyWith(Node<T> value, $Res Function(Node<T>) then) =
      _$NodeCopyWithImpl<T, $Res>;
  $Res call(
      {@KeyOrNullConverter() Key key,
      String label,
      @IconDataOrNullConverter() IconData? icon,
      @ColorOrNullConverter() Color? iconColor,
      @ColorOrNullConverter() Color? selectedIconColor,
      bool expanded,
      @GenericConverter() T? data,
      @NodeConverter() List<Node<T>> children});
}

/// @nodoc
class _$NodeCopyWithImpl<T, $Res> implements $NodeCopyWith<T, $Res> {
  _$NodeCopyWithImpl(this._value, this._then);

  final Node<T> _value;
  // ignore: unused_field
  final $Res Function(Node<T>) _then;

  @override
  $Res call({
    Object? key = freezed,
    Object? label = freezed,
    Object? icon = freezed,
    Object? iconColor = freezed,
    Object? selectedIconColor = freezed,
    Object? expanded = freezed,
    Object? data = freezed,
    Object? children = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as Key,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: icon == freezed
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData?,
      iconColor: iconColor == freezed
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      selectedIconColor: selectedIconColor == freezed
          ? _value.selectedIconColor
          : selectedIconColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      expanded: expanded == freezed
          ? _value.expanded
          : expanded // ignore: cast_nullable_to_non_nullable
              as bool,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      children: children == freezed
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<Node<T>>,
    ));
  }
}

/// @nodoc
abstract class _$$_NodeCopyWith<T, $Res> implements $NodeCopyWith<T, $Res> {
  factory _$$_NodeCopyWith(_$_Node<T> value, $Res Function(_$_Node<T>) then) =
      __$$_NodeCopyWithImpl<T, $Res>;
  @override
  $Res call(
      {@KeyOrNullConverter() Key key,
      String label,
      @IconDataOrNullConverter() IconData? icon,
      @ColorOrNullConverter() Color? iconColor,
      @ColorOrNullConverter() Color? selectedIconColor,
      bool expanded,
      @GenericConverter() T? data,
      @NodeConverter() List<Node<T>> children});
}

/// @nodoc
class __$$_NodeCopyWithImpl<T, $Res> extends _$NodeCopyWithImpl<T, $Res>
    implements _$$_NodeCopyWith<T, $Res> {
  __$$_NodeCopyWithImpl(_$_Node<T> _value, $Res Function(_$_Node<T>) _then)
      : super(_value, (v) => _then(v as _$_Node<T>));

  @override
  _$_Node<T> get _value => super._value as _$_Node<T>;

  @override
  $Res call({
    Object? key = freezed,
    Object? label = freezed,
    Object? icon = freezed,
    Object? iconColor = freezed,
    Object? selectedIconColor = freezed,
    Object? expanded = freezed,
    Object? data = freezed,
    Object? children = freezed,
  }) {
    return _then(_$_Node<T>(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as Key,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: icon == freezed
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData?,
      iconColor: iconColor == freezed
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      selectedIconColor: selectedIconColor == freezed
          ? _value.selectedIconColor
          : selectedIconColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      expanded: expanded == freezed
          ? _value.expanded
          : expanded // ignore: cast_nullable_to_non_nullable
              as bool,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      children: children == freezed
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<Node<T>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Node<T> extends _Node<T> {
  const _$_Node(
      {@KeyOrNullConverter() required this.key,
      required this.label,
      @IconDataOrNullConverter() this.icon,
      @ColorOrNullConverter() this.iconColor,
      @ColorOrNullConverter() this.selectedIconColor,
      this.expanded = false,
      @GenericConverter() this.data,
      @NodeConverter() final List<Node<T>> children = const []})
      : _children = children,
        super._();

  factory _$_Node.fromJson(Map<String, dynamic> json) => _$$_NodeFromJson(json);

  /// The unique string that identifies this object.
  @override
  @KeyOrNullConverter()
  final Key key;

  /// The string value that is displayed on the [TreeNode].
  @override
  final String label;

  /// An optional icon that is displayed on the [TreeNode].
  @override
  @IconDataOrNullConverter()
  final IconData? icon;

  /// An optional color that will be applied to the icon for this node.
  @override
  @ColorOrNullConverter()
  final Color? iconColor;

  /// An optional color that will be applied to the icon when this node
  /// is selected.
  @override
  @ColorOrNullConverter()
  final Color? selectedIconColor;

  /// The open or closed state of the [TreeNode]. Applicable only if the
  /// node is a parent
  @override
  @JsonKey()
  final bool expanded;

  /// Generic data model that can be assigned to the [TreeNode]. This makes
  /// it useful to assign and retrieve data associated with the [TreeNode]
  @override
  @GenericConverter()
  final T? data;

  /// The sub [Node]s of this object.
  final List<Node<T>> _children;

  /// The sub [Node]s of this object.
  @override
  @JsonKey()
  @NodeConverter()
  List<Node<T>> get children {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'Node<$T>(key: $key, label: $label, icon: $icon, iconColor: $iconColor, selectedIconColor: $selectedIconColor, expanded: $expanded, data: $data, children: $children)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Node<T> &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality().equals(other.label, label) &&
            const DeepCollectionEquality().equals(other.icon, icon) &&
            const DeepCollectionEquality().equals(other.iconColor, iconColor) &&
            const DeepCollectionEquality()
                .equals(other.selectedIconColor, selectedIconColor) &&
            const DeepCollectionEquality().equals(other.expanded, expanded) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(label),
      const DeepCollectionEquality().hash(icon),
      const DeepCollectionEquality().hash(iconColor),
      const DeepCollectionEquality().hash(selectedIconColor),
      const DeepCollectionEquality().hash(expanded),
      const DeepCollectionEquality().hash(data),
      const DeepCollectionEquality().hash(_children));

  @JsonKey(ignore: true)
  @override
  _$$_NodeCopyWith<T, _$_Node<T>> get copyWith =>
      __$$_NodeCopyWithImpl<T, _$_Node<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NodeToJson(this);
  }
}

abstract class _Node<T> extends Node<T> {
  const factory _Node(
      {@KeyOrNullConverter() required final Key key,
      required final String label,
      @IconDataOrNullConverter() final IconData? icon,
      @ColorOrNullConverter() final Color? iconColor,
      @ColorOrNullConverter() final Color? selectedIconColor,
      final bool expanded,
      @GenericConverter() final T? data,
      @NodeConverter() final List<Node<T>> children}) = _$_Node<T>;
  const _Node._() : super._();

  factory _Node.fromJson(Map<String, dynamic> json) = _$_Node<T>.fromJson;

  @override

  /// The unique string that identifies this object.
  @KeyOrNullConverter()
  Key get key => throw _privateConstructorUsedError;
  @override

  /// The string value that is displayed on the [TreeNode].
  String get label => throw _privateConstructorUsedError;
  @override

  /// An optional icon that is displayed on the [TreeNode].
  @IconDataOrNullConverter()
  IconData? get icon => throw _privateConstructorUsedError;
  @override

  /// An optional color that will be applied to the icon for this node.
  @ColorOrNullConverter()
  Color? get iconColor => throw _privateConstructorUsedError;
  @override

  /// An optional color that will be applied to the icon when this node
  /// is selected.
  @ColorOrNullConverter()
  Color? get selectedIconColor => throw _privateConstructorUsedError;
  @override

  /// The open or closed state of the [TreeNode]. Applicable only if the
  /// node is a parent
  bool get expanded => throw _privateConstructorUsedError;
  @override

  /// Generic data model that can be assigned to the [TreeNode]. This makes
  /// it useful to assign and retrieve data associated with the [TreeNode]
  @GenericConverter()
  T? get data => throw _privateConstructorUsedError;
  @override

  /// The sub [Node]s of this object.
  @NodeConverter()
  List<Node<T>> get children => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_NodeCopyWith<T, _$_Node<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
