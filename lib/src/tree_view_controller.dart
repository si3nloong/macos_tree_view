import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'color_converter.dart';
import 'generic_converter.dart';
import 'icon_data_converter.dart';
import 'key_converter.dart';
import 'tree_view.dart';

part 'tree_view_controller.g.dart';

const _kDefaultIconColor = Color.fromRGBO(0, 122, 255, 1);

final r = Random();
String _randomString(int len) {
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}

@KeyOrNullConverter()
@ColorOrNullConverter()
@IconDataOrNullConverter()
@JsonSerializable()
@GenericConverter()
class Node<T> extends Comparable<Node<T>> with ChangeNotifier {
  /// The unique string that identifies this object.
  final Key key;

  /// The string value that is displayed on the [Node].
  String _label;
  String get label => _label;

  /// An optional icon that is displayed on the [Node].
  IconData? _icon;
  IconData? get icon => _icon;

  /// An optional color that will be applied to the icon for this node.
  Color? _iconColor;
  Color? get iconColor => _iconColor;

  /// An optional color that will be applied to the icon when this node
  /// is selected.
  final Color? _selectedIconColor;
  Color? get selectedIconColor => _selectedIconColor;

  /// The open or closed state of the [Node]. Applicable only if the
  /// node is a parent
  bool _expanded;
  bool get expanded => _expanded;

  /// The open or closed state of the [Node]. Applicable only if the
  /// node is a parent
  bool _selected;
  bool get selected => _selected;

  /// Record the parent [Node], for traversal purpose.
  /// If `null`, this node is the root of the tree
  /// or it doesn't belong to any [Node] yet.
  ///
  Node<T>? _parent;
  Node<T>? get parent => _parent;

  /// The nested depth of the [Node].
  int get depth => isRoot ? 0 : ancestors.length - 1;

  /// The sub [Node]s of this object.
  List<Node<T>> _children;
  List<Node<T>> get children => List.unmodifiable(_children);

  /// Generic data model that can be assigned to the [TreeNode]. This makes
  /// it useful to assign and retrieve data associated with the [TreeNode]
  T? data;

  Node({
    required this.key,
    required String label,
    IconData? icon,
    Color? iconColor,
    Color? selectedIconColor,
    bool expanded = false,
    List<Node<T>>? children,
    this.data,
  })  : _label = label,
        _icon = icon,
        _iconColor = iconColor,
        _selectedIconColor = selectedIconColor ?? _kDefaultIconColor,
        _expanded = expanded,
        _selected = false,
        _children = children ?? [];

  Node<T> copyWith({
    Key? key,
    String? label,
    IconData? icon,
    Color? iconColor,
    Color? selectedIconColor,
    bool? expanded,
    List<Node<T>>? children,
    T? data,
  }) {
    return Node(
      key: key ?? this.key,
      label: label ?? _label,
      icon: icon ?? _icon,
      iconColor: iconColor ?? _iconColor,
      selectedIconColor: selectedIconColor ?? _selectedIconColor,
      expanded: expanded ?? _expanded,
      children: (children ?? _children).toList(),
      data: data ?? this.data,
    );
  }

  /// A necessary factory constructor for creating a new Node instance
  /// from a map. Pass the map to the generated `_$NodeFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Node.
  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$NodeToJson`.
  Map<String, dynamic> toJson() => _$NodeToJson(this);

  /// Creates a [Node] from a string value.
  /// By default, if key is not provided, it will generates a unique key.
  factory Node.fromLabel(String label,
      {Key? key, T? data, IconData? icon, List<Node<T>>? children}) {
    return Node<T>(
      key: key ?? Key(_randomString(10)),
      label: label,
      data: data,
      icon: icon,
      children: children ?? [],
    );
  }

  /// Search the node that has a key value equal to the specified key.
  Node<T>? findChild(Key key) {
    final iter = descendants.iterator;
    Node<T>? found;
    while (iter.moveNext()) {
      if (iter.current.key == key) {
        found = iter.current;
        break;
      }
    }
    return found;
  }

  /// Adds a single child to this node and sets its [parent] property to `this`.
  ///
  /// If [child]'s `parent != null`, it will be removed from the children of
  /// it's old parent before being added to this.
  void addChild(Node<T> child, [InsertMode mode = InsertMode.append]) {
    _addChild(child);
    notifyListeners();
  }

  /// Adds a list of children to this node.
  void addChildren(Iterable<Node<T>> children) {
    children.forEach(_addChild);
    notifyListeners();
  }

  /// Removes a single child from this node and set its parent to `null`.
  void removeChild(Key key, {bool recursive = false}) {
    final child = findChild(key);
    if (child == null) {
      return;
    }
    if (recursive) {
      _children.remove(child);
    } else {
      _children
        ..addAll(child._children..forEach((el) => el.._parent = this))
        ..remove(child);
    }
    notifyListeners();
  }

  void toggleSelect([bool? value]) {
    if (value == null) {
      _selected = !_selected;
    } else {
      _selected = value;
    }
    notifyListeners();
  }

  void toggleExpand([bool? value]) {
    if (value == null) {
      _expanded = !_expanded;
    } else {
      _expanded = value;
    }
    notifyListeners();
  }

  void _addChild(Node<T> child) {
    // assert(child == parent || child == this);
    // A node can't be neither child of its children nor parent of itself.
    if (child == parent || child == this) {
      return;
    }

    child._parent = this;
    _children.add(child);
  }

  /// Returns the path from the root [Node] to this node, not including this.
  ///
  /// Example: [root, child, grandChild, ..., this.parent].
  Iterable<Node<T>> get ancestors sync* {
    if (parent != null) {
      yield* parent!.ancestors;
      yield parent!;
    }
  }

  /// Returns an [Iterable] of every [Node] under this.
  Iterable<Node<T>> get descendants sync* {
    for (final child in _children) {
      yield child;
      if (child.children.isNotEmpty) {
        yield* child.descendants;
      }
    }
  }

  /// Set this [Node] to sortable
  @override
  int compareTo(Node<T> other) => label.compareTo(other.label);

  /// Whether or not this [Node] is the root.
  bool get isRoot => _parent == null;

  /// Returns the first child of this [Node] or `null` if [children] is empty.
  Node<T>? get firstChild => _children.isEmpty ? null : _children.first;

  /// Returns the last child of this [Node] or `null` if [children] is empty.
  Node<T>? get lastChild => _children.isEmpty ? null : _children.last;

  /// Whether or not this [Node] is the last child of its parent.
  ///
  /// If this method throws, the tree was malformed.
  bool get hasNextSibling => isRoot ? !isRoot : this != parent!.lastChild;

  /// Whether this [Node] has parent.
  bool get hasParent => _parent != null;

  /// Whether this [Node] has a non-null icon.
  bool get hasIcon => _icon != null && _icon != null;

  /// Whether this [Node] has data associated with it.
  bool get hasData => data != null;

  /// Whether this [Node] has children.
  bool get hasChildren => _children.isNotEmpty;

  @override
  String toString() =>
      'Node(key: $key, isRoot: $isRoot, depth: $depth, label: $label, expanded: $expanded, selected: $selected)';
}

/// Defines the insertion mode adding a new [Node] to the [TreeView].
enum InsertMode {
  prepend,
  append,
  insert,
}

List<Node<T>> _mapToChildren<T>(
    Node<T>? parent, int depth, List<Node<T>> nodes) {
  return nodes.map((e) {
    final newClone = e.copyWith();

    newClone
      .._parent = parent
      .._children = _mapToChildren(newClone, depth + 1, newClone._children);
    return newClone;
  }).toList();
}

/// The controller for [TreeView].
@KeyOrNullConverter()
@JsonSerializable()
class TreeViewController<T> extends ChangeNotifier {
  TreeViewController({
    Set<Key>? selectedValues,
    SelectionMode selectionMode = SelectionMode.single,
    List<Node<T>>? children,
  })  : assert(selectionMode == SelectionMode.single &&
            (selectedValues ?? {}).length < 2),
        _selectedValues = {},
        _selectionMode = selectionMode,
        // _children = _mapToChildren<T>(null, 0, children ?? []),
        super() {
    final root = Node<T>.fromLabel('@root');
    _root = root.._children = _mapToChildren(root, 0, children ?? []);
  }

  /// The key of the select node in the [TreeView].
  final Set<Node<T>> _selectedValues;
  Set<Key> get selectedValues =>
      Set.unmodifiable(_selectedValues.map((e) => e.key));

  late final Node<T> _root;
  Node<T> get root => _root;

  /// The nodes for the [TreeView].
  // final List<Node<T>> _children;
  List<Node<T>> get children => List.unmodifiable(_root.children);
  // set children(List<Node<T>> value) {
  //   _children = _mapToChildren<T>(null, 0, value);
  //   notifyListeners();
  // }

  /// The selection mode for the [TreeView].
  SelectionMode _selectionMode;
  SelectionMode get selectionMode => _selectionMode;
  set selectionMode(SelectionMode value) {
    if (value == SelectionMode.none) {
      _selectedValues
        ..forEach((el) => el.toggleSelect(false))
        ..clear();
    } else if (value == SelectionMode.single && _selectedValues.isNotEmpty) {
      final first = _selectedValues.first;
      _selectedValues
        ..forEach((el) => el.toggleSelect(false))
        ..clear()
        ..add(first..toggleSelect(true));
    }
    _selectionMode = value;
    notifyListeners();
  }

  /// Returns an [Iterable] of every [Node] under this.
  Iterable<Node<T>> get descendants sync* {
    for (final child in _root.children) {
      yield child;

      if (child.children.isNotEmpty) {
        yield* child.descendants;
      }
    }
  }

  // /// Creates a copy of this controller but with the given fields
  // /// replaced with the new values.
  // ///
  // /// ```dart
  // /// controller = TreeViewController<String>();
  // ///
  // /// setState(() {
  // ///   controller.copyWith();
  // /// });
  // /// ```
  // // TreeViewController<T> copyWith({
  // //   List<Node<T>>? nodes,
  // //   Set<Key>? initialNodes,
  // //   SelectionMode? selectionMode,
  // // }) {
  // //   return TreeViewController<T>(
  // //     nodes: nodes ?? _nodes,
  // //     initialNodes: initialNodes ?? _selectedNodes,
  // //     selectionMode: selectionMode ?? _selectionMode,
  // //   );
  // // }

  /// Loads this controller with data from a JSON String
  /// This method expects the user to properly update the state
  ///
  /// ```dart
  /// setState(() {
  ///   TreeViewController.loadFromJson(json: jsonString);
  /// });
  /// ```
  // static TreeViewController<T> loadFromJson<T>({String json = '{}'}) {
  //   // final jsonList = jsonDecode(json) as List<dynamic>;
  //   // final List<Map<String, dynamic>> list =
  //   //     List<Map<String, dynamic>>.from(jsonList);
  //   // return loadFromMap<T>(list: list);
  //   return TreeViewController();
  // }

  // /// Loads this controller with data from a Map.
  // /// This method expects the user to properly update the state
  // ///
  // /// ```dart
  // /// setState(() {
  // ///   controller = controller.loadFromMap(list: dataMap);
  // /// });
  // /// ```
  // static TreeViewController<T> loadFromMap<T>(
  //     {List<Map<String, dynamic>> list = const []}) {
  //   final List<Node<T>> treeData = list
  //       .map((Map<String, dynamic> item) => Node.fromJson(item) as Node<T>)
  //       .toList();
  //   return TreeViewController<T>(nodes: treeData);
  // }

  /// Search the node that has a key value equal to the specified key.
  Node<T>? findNode(Key key) {
    final iter = _root.descendants.iterator;
    Node<T>? found;
    while (iter.moveNext()) {
      if (iter.current.key == key) {
        found = iter.current;
        break;
      }
    }
    return found;
  }

  /// Adds a new node to an existing node identified by specified key. It optionally
  /// accepts an [InsertMode] and index. If no [InsertMode] is specified,
  /// it appends the new node as a child at the end. This method returns
  /// a new list with the added node.
  void addNode(
    Node<T> newNode, {
    Key? parent,
    InsertMode mode = InsertMode.append,
  }) {
    if (parent != null) {
      // Set node's parent for referencing purpose.
      final node = findNode(parent);
      assert(node != null && parent != root.key);
      node!.addChild(newNode);
    } else if (mode == InsertMode.append) {
      // If parent not specify, we append it to root node.
      _root.addChild(newNode);
    }
    notifyListeners();
  }

  // void updateNode(
  //   Key key, {
  //   String? label,
  //   List<Node<T>>? children,
  //   bool? expanded,
  //   IconData? icon,
  //   Color? iconColor,
  // }) {
  //   final node = findNode(key);
  //   if (node == null) {
  //     return;
  //   }

  //   node._label = label ?? node._label;
  //   node._children = children ?? node._children;
  //   node._expanded = expanded ?? node._expanded;
  //   node._icon = icon ?? node._icon;
  //   node._iconColor = iconColor ?? node._iconColor;
  //   notifyListeners();
  // }

  void removeNode(Key key, {bool recursive = false}) {
    // If no node is found in the tree, should do nothing.
    final Node<T>? node = findNode(key);
    if (node == null) {
      return;
    }

    node.parent?.removeChild(node.key, recursive: recursive);
    notifyListeners();
  }

  void selectNode(Key key, {bool ancestorExpanded = false}) {
    if (_selectionMode == SelectionMode.none) {
      return;
    }

    // If no node is found in the tree, should do nothing.
    final Node<T>? node = findNode(key);
    if (node == null) {
      return;
    }

    if (_selectionMode == SelectionMode.single) {
      _selectedValues
        ..forEach((el) => el.toggleSelect(false))
        ..clear()
        ..add(node);
    } else {
      try {
        final found = _selectedValues.firstWhere(
            (element) => element.key == node.key,
            orElse: () => throw Error());

        _selectedValues.remove(found);
      } catch (e) {
        _selectedValues.add(node);
      }
    }

    node.toggleSelect();

    /// expanded every parent node until root node
    if (ancestorExpanded) {
      final iter = node.ancestors.iterator;
      while (iter.moveNext()) {
        iter.current.toggleExpand(true);
      }
    }
    notifyListeners();
  }

  /// Toggles an existing node identified by specified key. This method
  /// returns a new list with the specified [Node] toggled.
  void toggleNode(Key key) {
    final node = findNode(key);
    if (node == null) {
      return;
    }
    node.toggleExpand();
    notifyListeners();
  }

  /// Deletes an existing node identified by specified key. This method
  /// returns a new list with the specified node removed.
  // void removeNode(Key key) {
  //   final iter = _root.descendants.iterator;
  //   while (iter.moveNext()) {
  //     print(iter.current.key);
  //   }
  //   notifyListeners();
  // }

  /// Expands all node that are children of the parent node parameter. If no parent is passed, uses the root node as the parent.
  void expandAll({Key? parent}) {
    final iter = descendants.iterator;
    while (iter.moveNext()) {
      iter.current.toggleExpand(true);
    }
    notifyListeners();
  }

  /// Collapses all node that are children of the parent node parameter. If no parent is passed, uses the root node as the parent.
  void collapseAll({Key? parent}) {
    final iter = descendants.iterator;
    while (iter.moveNext()) {
      iter.current.toggleExpand(false);
    }
    notifyListeners();
  }

  void resetSelection() {
    _selectedValues
      ..forEach((el) => el.toggleSelect(false))
      ..clear();
    notifyListeners();
  }

  // List<Node<T>> _applyToChildren({Key? parent, required bool expanded}) {
  //   final List<Node<T>> newChildren = [];
  //   final Iterator<Node<T>> iter = _children.iterator;
  //   while (iter.moveNext()) {
  //     final Node<T> child = iter.current;
  //     if (child.hasChildren) {
  //       newChildren.add(child.copyWith(
  //         expanded: expanded,
  //         children: _applyToChildren(parent: parent, expanded: expanded),
  //       ));
  //     } else {
  //       newChildren.add(child.copyWith(expanded: expanded));
  //     }
  //   }
  //   return newChildren;
  // }

  // /// Expands a node and all of the node's ancestors so that the node is
  // /// visible without the need to manually expand each node.
  // // List<Node> expandToNode(String key) {
  // //   List<String> _ancestors = [];
  // //   String _currentKey = key;

  // //   _ancestors.add(_currentKey);

  // //   Node? _parent = getParent(_currentKey);
  // //   if (_parent != null) {
  // //     while (_parent!.key != _currentKey) {
  // //       _currentKey = _parent.key;
  // //       _ancestors.add(_currentKey);
  // //       _parent = getParent(_currentKey);
  // //     }
  // //     TreeViewController _this = this;
  // //     for (var k in _ancestors) {
  // //       Node _node = _this.getNode(k)!;
  // //       Node _updated = _node.copyWith(expanded: true);
  // //       _this = _this.withUpdateNode(k, _updated);
  // //     }
  // //     return _this.value.children;
  // //   }
  // //   return value.children;
  // // }

  // /// Collapses a node and all of the node's ancestors without the need to
  // /// manually collapse each node.
  // // List<Node> collapseToNode(String key) {
  // //   List<String> _ancestors = [];
  // //   String _currentKey = key;

  // //   _ancestors.add(_currentKey);

  // //   Node? _parent = getParent(_currentKey);
  // //   if (_parent != null) {
  // //     while (_parent!.key != _currentKey) {
  // //       _currentKey = _parent.key;
  // //       _ancestors.add(_currentKey);
  // //       _parent = getParent(_currentKey);
  // //     }
  // //     TreeViewController _this = this;
  // //     for (var k in _ancestors) {
  // //       Node _node = _this.getNode(k)!;
  // //       Node _updated = _node.copyWith(expanded: false);
  // //       _this = _this.withUpdateNode(k, _updated);
  // //     }
  // //     return _this.value.children;
  // //   }
  // //   return value.children;
  // // }

  // List<Node<T>> _insertNode(
  //   Key key,
  //   Node<T> newNode, {
  //   Node<T>? parent,
  //   int? index,
  //   InsertMode mode = InsertMode.append,
  // }) {
  //   final List<Node<T>> children = parent == null ? _nodes : parent.children;
  //   return children.map((Node<T> child) {
  //     if (child.key == key) {
  //       final List<Node<T>> children = child.children.toList(growable: true);
  //       if (mode == InsertMode.prepend) {
  //         children.insert(0, newNode);
  //       } else if (mode == InsertMode.insert) {
  //         children.insert(index ?? children.length, newNode);
  //       } else {
  //         children.add(newNode);
  //       }
  //       return child.copyWith(children: children);
  //     } else {
  //       return child.copyWith(
  //         children: _insertNode(
  //           key,
  //           newNode,
  //           parent: child,
  //           mode: mode,
  //           index: index,
  //         ),
  //       );
  //     }
  //   }).toList();
  // }

  // /// Updates an existing node identified by specified key. This method
  // /// returns a new list with the updated node.
  // List<Node<T>> _updateNode(Key key, Node<T> newNode, {Node<T>? parent}) {
  //   final List<Node<T>> children = parent == null ? _nodes : parent.children;
  //   return children.map((Node<T> child) {
  //     if (child.key == key) {
  //       return newNode;
  //     }

  //     if (child.isParent) {
  //       return child.copyWith(
  //         children: _updateNode(
  //           key,
  //           newNode,
  //           parent: child,
  //         ),
  //       );
  //     }

  //     return child;
  //   }).toList();
  // }

  // /// Map representation of this object
  // List<Map<String, dynamic>> get asMap {
  //   return value.children.map((Node child) => child.asMap).toList();
  // }

  /// A necessary factory constructor for creating a new Node instance
  /// from a map. Pass the map to the generated `_$TreeViewControllerFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Node.
  factory TreeViewController.fromJson(Map<String, dynamic> json) =>
      _$TreeViewControllerFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TreeViewControllerToJson`.
  Map<String, dynamic> toJson() => _$TreeViewControllerToJson(this);

  @override
  String toString() =>
      'TreeViewController<$T>(selectionMode: $selectionMode, nodes: $children, selectedValues: $selectedValues)';
}
