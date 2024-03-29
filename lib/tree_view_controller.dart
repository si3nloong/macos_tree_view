import 'dart:convert';

import 'package:flutter/material.dart';

import 'node.dart';
import 'tree_view.dart';

/// Defines the insertion mode adding a new [Node] to the [TreeView].
enum InsertMode {
  prepend,
  append,
  insert,
}

/// The controller for [TreeView].
class TreeViewController<T> extends ChangeNotifier {
  TreeViewController({
    List<Node<T>>? nodes,
    Set<Key>? initialNodes,
    SelectionMode? selectionMode,
  })  : _nodes = nodes ?? [],
        _selectedNodes = initialNodes ?? {},
        _selectionMode = selectionMode ?? SelectionMode.single,
        super();

  /// The key of the select node in the [TreeView].
  Set<Key> _selectedNodes;
  Set<Key> get selectedNodes => _selectedNodes;
  set selectedNodes(Set<Key> value) {
    _selectedNodes = value;
    notifyListeners();
  }

  /// The nodes for the [TreeView].
  List<Node<T>> _nodes;
  List<Node<T>> get nodes => _nodes;

  /// The selection mode for the [TreeView].
  SelectionMode _selectionMode;
  SelectionMode get selectionMode => _selectionMode;
  set selectionMode(SelectionMode value) {
    _selectionMode = value;
    notifyListeners();
  }

  /// Creates a copy of this controller but with the given fields
  /// replaced with the new values.
  ///
  /// ```dart
  /// controller = TreeViewController<String>();
  ///
  /// setState(() {
  ///   controller.copyWith();
  /// });
  /// ```
  TreeViewController<T> copyWith({
    List<Node<T>>? nodes,
    Set<Key>? initialNodes,
    SelectionMode? selectionMode,
  }) {
    return TreeViewController<T>(
      nodes: nodes ?? _nodes,
      initialNodes: initialNodes ?? _selectedNodes,
      selectionMode: selectionMode ?? _selectionMode,
    );
  }

  /// Loads this controller with data from a JSON String
  /// This method expects the user to properly update the state
  ///
  /// ```dart
  /// setState(() {
  ///   TreeViewController.loadFromJson(json: jsonString);
  /// });
  /// ```
  static TreeViewController<T> loadFromJson<T>({String json = '[]'}) {
    final jsonList = jsonDecode(json) as List<dynamic>;
    final List<Map<String, dynamic>> list =
        List<Map<String, dynamic>>.from(jsonList);
    return loadFromMap<T>(list: list);
  }

  /// Loads this controller with data from a Map.
  /// This method expects the user to properly update the state
  ///
  /// ```dart
  /// setState(() {
  ///   controller = controller.loadFromMap(list: dataMap);
  /// });
  /// ```
  static TreeViewController<T> loadFromMap<T>(
      {List<Map<String, dynamic>> list = const []}) {
    final List<Node<T>> treeData = list
        .map((Map<String, dynamic> item) => Node.fromJson(item) as Node<T>)
        .toList();
    return TreeViewController<T>(nodes: treeData);
  }

  /// Gets the node that has a key value equal to the specified key.
  Node<T>? findNode(Key key, {Node<T>? parent}) {
    Node<T>? found;
    final List<Node<T>> children = parent == null ? _nodes : parent.children;
    final iter = children.iterator;
    while (iter.moveNext()) {
      final child = iter.current;
      if (child.key == key) {
        found = child;
        break;
      } else {
        if (child.isParent) {
          found = findNode(key, parent: child);
          if (found != null) {
            break;
          }
        }
      }
    }
    return found;
  }

  /// Gets the parent of the node identified by specified key.
  Node<T>? findParent(Key key, {Node<T>? parent}) {
    Node<T>? found;
    final List<Node<T>> children = parent == null ? _nodes : parent.children;
    final iter = children.iterator;
    while (iter.moveNext()) {
      final child = iter.current;
      if (child.key == key) {
        found = parent ?? child;
        break;
      } else {
        if (child.isParent) {
          found = findParent(key, parent: child);
          if (found != null) {
            break;
          }
        }
      }
    }
    return found;
  }

  /// Adds a new node to an existing node identified by specified key. It optionally
  /// accepts an [InsertMode] and index. If no [InsertMode] is specified,
  /// it appends the new node as a child at the end. This method returns
  /// a new list with the added node.
  void addNode(
    Key key,
    Node<T> newNode, {
    Node<T>? parent,
    int? index,
    InsertMode mode = InsertMode.append,
  }) {
    _nodes =
        _insertNode(key, newNode, parent: parent, index: index, mode: mode);
    notifyListeners();
  }

  void updateNode(Key key, Node<T> newNode, {Node<T>? parent}) {
    _nodes = _updateNode(key, newNode, parent: parent);
    notifyListeners();
  }

  void selectNode(Key key) {
    if (_selectionMode == SelectionMode.none) {
      return;
    }

    final Node<T>? node = findNode(key);
    if (node == null) {
      return;
    }

    if (_selectionMode == SelectionMode.single) {
      _selectedNodes = {key};
    } else {
      final list = _selectedNodes.toSet();
      list.add(key);
      _selectedNodes = list;
    }
    final List<Node<T>> ancestors = [];
    //   String _currentKey = key;

    //   _ancestors.add(_currentKey);

    Node<T>? parent = findParent(key);
    if (parent != null) {
      while (parent!.key != key) {
        key = parent.key;
        ancestors.add(parent);
        parent = findParent(key);
      }
    }
    //     TreeViewController _this = this;
    //     for (var k in _ancestors) {
    //       Node _node = _this.getNode(k)!;
    //       Node _updated = _node.copyWith(expanded: true);
    //       _this = _this.withUpdateNode(k, _updated);
    //     }
    //     return _this.value.children;
    //   }
    notifyListeners();
  }

  /// Toggles an existing node identified by specified key. This method
  /// returns a new list with the specified node toggled.
  void toggleNode(Key key, {Node<T>? parent}) {
    final Node<T>? node = findNode(key, parent: parent);
    if (node == null) {
      return;
    }
    _nodes = _updateNode(key, node.copyWith(expanded: !node.expanded));
    notifyListeners();
  }

  /// Expands all node that are children of the parent node parameter. If no parent is passed, uses the root node as the parent.
  void expandAll({Node<T>? parent}) {
    _nodes = _mapDescendants(
        parent: parent, mapper: (v) => v.copyWith(expanded: true));
    notifyListeners();
  }

  /// Collapses all node that are children of the parent node parameter. If no parent is passed, uses the root node as the parent.
  void collapseAll({Node<T>? parent}) {
    _nodes = _mapDescendants(
        parent: parent, mapper: (v) => v.copyWith(expanded: false));
    notifyListeners();
  }

  List<Node<T>> _mapDescendants(
      {Node<T>? parent, required Node<T> Function(Node<T>) mapper}) {
    final List<Node<T>> children = [];
    final Iterator<Node<T>> iter =
        parent == null ? _nodes.iterator : parent.children.iterator;
    while (iter.moveNext()) {
      final Node<T> child = iter.current;
      if (child.isParent) {
        children.add(child.copyWith(
          expanded: true,
          children: _mapDescendants(parent: child, mapper: mapper),
        ));
      } else {
        children.add(child);
      }
    }
    return children;
  }

  /// Expands a node and all of the node's ancestors so that the node is
  /// visible without the need to manually expand each node.
  // List<Node> expandToNode(String key) {
  //   List<String> _ancestors = [];
  //   String _currentKey = key;

  //   _ancestors.add(_currentKey);

  //   Node? _parent = getParent(_currentKey);
  //   if (_parent != null) {
  //     while (_parent!.key != _currentKey) {
  //       _currentKey = _parent.key;
  //       _ancestors.add(_currentKey);
  //       _parent = getParent(_currentKey);
  //     }
  //     TreeViewController _this = this;
  //     for (var k in _ancestors) {
  //       Node _node = _this.getNode(k)!;
  //       Node _updated = _node.copyWith(expanded: true);
  //       _this = _this.withUpdateNode(k, _updated);
  //     }
  //     return _this.value.children;
  //   }
  //   return value.children;
  // }

  /// Collapses a node and all of the node's ancestors without the need to
  /// manually collapse each node.
  // List<Node> collapseToNode(String key) {
  //   List<String> _ancestors = [];
  //   String _currentKey = key;

  //   _ancestors.add(_currentKey);

  //   Node? _parent = getParent(_currentKey);
  //   if (_parent != null) {
  //     while (_parent!.key != _currentKey) {
  //       _currentKey = _parent.key;
  //       _ancestors.add(_currentKey);
  //       _parent = getParent(_currentKey);
  //     }
  //     TreeViewController _this = this;
  //     for (var k in _ancestors) {
  //       Node _node = _this.getNode(k)!;
  //       Node _updated = _node.copyWith(expanded: false);
  //       _this = _this.withUpdateNode(k, _updated);
  //     }
  //     return _this.value.children;
  //   }
  //   return value.children;
  // }

  List<Node<T>> _insertNode(
    Key key,
    Node<T> newNode, {
    Node<T>? parent,
    int? index,
    InsertMode mode = InsertMode.append,
  }) {
    final List<Node<T>> children = parent == null ? _nodes : parent.children;
    return children.map((Node<T> child) {
      if (child.key == key) {
        final List<Node<T>> children = child.children.toList(growable: true);
        if (mode == InsertMode.prepend) {
          children.insert(0, newNode);
        } else if (mode == InsertMode.insert) {
          children.insert(index ?? children.length, newNode);
        } else {
          children.add(newNode);
        }
        return child.copyWith(children: children);
      } else {
        return child.copyWith(
          children: _insertNode(
            key,
            newNode,
            parent: child,
            mode: mode,
            index: index,
          ),
        );
      }
    }).toList();
  }

  /// Updates an existing node identified by specified key. This method
  /// returns a new list with the updated node.
  List<Node<T>> _updateNode(Key key, Node<T> newNode, {Node<T>? parent}) {
    final List<Node<T>> children = parent == null ? _nodes : parent.children;
    return children.map((Node<T> child) {
      if (child.key == key) {
        return newNode;
      }

      if (child.isParent) {
        return child.copyWith(
          children: _updateNode(
            key,
            newNode,
            parent: child,
          ),
        );
      }

      return child;
    }).toList();
  }

  /// Deletes an existing node identified by specified key. This method
  /// returns a new list with the specified node removed.
  // List<Node> deleteNode<T>(String key, {Node? parent}) {
  //   List<Node> _children = parent == null ? value.children : parent.children;
  //   List<Node<T>> _filteredChildren = [];
  //   Iterator iter = _children.iterator;
  //   while (iter.moveNext()) {
  //     Node<T> child = iter.current;
  //     if (child.key != key) {
  //       if (child.isParent) {
  //         _filteredChildren.add(child.copyWith(
  //           children: deleteNode<T>(key, parent: child),
  //         ));
  //       } else {
  //         _filteredChildren.add(child);
  //       }
  //     }
  //   }
  //   return _filteredChildren;
  // }

  // /// Map representation of this object
  // List<Map<String, dynamic>> get asMap {
  //   return value.children.map((Node child) => child.asMap).toList();
  // }

  @override
  String toString() => 'TreeViewController<$T>(selectionMode: $selectionMode)';
}
