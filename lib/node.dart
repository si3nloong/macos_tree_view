import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'color_converter.dart';
import 'generic_converter.dart';
import 'icon_data_converter.dart';
import 'key_converter.dart';
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
    @KeyOrNullConverter() required Key key,

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
  static Node<T> fromLabel<T>(String label,
      {Key? key, T? data, IconData? icon}) {
    return Node<T>(
      key: key ?? GlobalKey(),
      label: label,
      data: data,
      icon: icon,
      children: [],
    );
  }

  /// Whether this object has children [Node].
  bool get isParent => children.isNotEmpty;

  /// Whether this object has a non-null icon.
  bool get hasIcon => icon != null && icon != null;

  /// Whether this object has data associated with it.
  bool get hasData => data != null;
}
