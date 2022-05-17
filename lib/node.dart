// ignore: unused_import
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'color_converter.dart';
import 'generic_converter.dart';
import 'icon_data_converter.dart';
import 'node_converter.dart';

part 'node.freezed.dart';
part 'node.g.dart';

/// Defines the data used to display a [TreeNode].
///
/// Used by [TreeView] to display a [TreeNode].
///
/// This object allows the creation of key, label and icon to display
/// a node on the [TreeView] widget. The key and label properties are
/// required. The key is needed for events that occur on the generated
/// [TreeNode]. It should always be unique.
///
@freezed
// @JsonSerializable(genericArgumentFactories: true)
class Node<T> with _$Node<T> {
  const factory Node({
    /// The unique string that identifies this object.
    required String key,

    /// The string value that is displayed on the [TreeNode].
    required String label,

    /// An optional icon that is displayed on the [TreeNode].
    @IconDataOrNullConverter() IconData? icon,

    /// An optional color that will be applied to the icon for this node.
    @ColorOrNullConverter() Color? iconColor,

    /// An optional color that will be applied to the icon when this node
    /// is selected.
    @ColorOrNullConverter() Color? selectedIconColor,

    /// The open or closed state of the [TreeNode]. Applicable only if the
    /// node is a parent
    @Default(false) bool expanded,

    /// Generic data model that can be assigned to the [TreeNode]. This makes
    /// it useful to assign and retrieve data associated with the [TreeNode]
    @GenericConverter() T? data,

    /// The sub [Node]s of this object.
    @NodeConverter() @Default([]) List<Node<T>> children,

    /// Force the node to be a parent so that node can show expander without
    /// having children node.
    // bool parent,
  }) = _Node<T>;

  const Node._();

  factory Node.fromJson(Map<String, Object?> json) => _$NodeFromJson<T>(json);

  /// Creates a [Node] from a string value. It generates a unique key.
  // static Node<T> fromLabel<T>(String label, {T data}) {
  //   final String key = GlobalKey().toString();
  //   return Node<T>(
  //     key: '${key}_$label',
  //     label: label,
  //     children: [],
  //      data: data
  //   );
  // }

  /// Creates a [Node] from a Map<String, dynamic> map. The map
  /// should contain a "label" value. If the key value is
  /// missing, it generates a unique key.
  /// If the expanded value, if present, can be any 'truthful'
  /// value. Excepted values include: 1, yes, true and their
  /// associated string values.
  // static Node<T> fromMap<T>(Map<String, dynamic> map) {
  //   final String key = map['key'] ?? GlobalKey().toString();
  //   final String label = map['label'];
  //   final data = map['data'];
  //   List<Node> children = [];
  //   // if (map['icon'] != null) {
  //   // int _iconData = int.parse(map['icon']);
  //   // if (map['icon'].runtimeType == String) {
  //   //   _iconData = int.parse(map['icon']);
  //   // } else if (map['icon'].runtimeType == double) {
  //   //   _iconData = (map['icon'] as double).toInt();
  //   // } else {
  //   //   _iconData = map['icon'];
  //   // }
  //   // _icon = const IconData(_iconData);
  //   // }
  //   if (map['children'] != null) {
  //     final List<Map<String, dynamic>> childrenMap = List.from(map['children']);
  //     children = childrenMap
  //         .map((Map<String, dynamic> child) => Node.fromMap(child))
  //         .toList();
  //   }
  //   return Node<T>(
  //     key: key,
  //     label: label,
  //     data: data,
  //     // FIXME:
  //     // expanded: Utilities.truthful(map['expanded']),
  //     // parent: Utilities.truthful(map['parent']),
  //     children: children,
  //   );
  // }

  /// Creates a copy of this object but with the given fields
  /// replaced with the new values.
  // @override
  // Node<T> copyWith({
  //   String? key,
  //   String? label,
  //   List<Node<T>>? children,
  //   bool? expanded,
  //   bool? parent,
  //   IconData? icon,
  //   Color? iconColor,
  //   Color? selectedIconColor,
  //   T? data,
  // }) =>
  //     Node<T>(
  //       key: key ?? this.key,
  //       label: label ?? this.label,
  //       icon: icon ?? this.icon,
  //       iconColor: iconColor ?? this.iconColor,
  //       selectedIconColor: selectedIconColor ?? this.selectedIconColor,
  //       expanded: expanded ?? this.expanded,
  //       parent: parent ?? this.parent,
  //       children: children ?? this.children,
  //       data: data ?? this.data,
  //     );

  /// Whether this object has children [Node].
  bool get isParent => children.isNotEmpty;

  /// Whether this object has a non-null icon.
  bool get hasIcon => icon != null && icon != null;

  /// Whether this object has data associated with it.
  bool get hasData => data != null;

  @override
  String toString() {
    return jsonEncode(this);
  }
}
