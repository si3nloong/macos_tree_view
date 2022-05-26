import 'dart:collection';

import 'package:flutter/material.dart';

import 'macos_tree_view.dart';

bool debugNodesHaveDuplicateKeys<T>(Iterable<Node<T>> items) {
  assert(() {
    final Key? nonUniqueKey = _firstNonUniqueKey<T>(HashSet<Key>(), items);
    if (nonUniqueKey != null) {
      throw FlutterError('Duplicate key found: $nonUniqueKey.');
    }
    return true;
  }());
  return false;
}

Key? _firstNonUniqueKey<T>(Set<Key> keySet, Iterable<Node<T>> items) {
  for (final item in items) {
    if (!keySet.add(item.key)) {
      return item.key;
    }

    final found = _firstNonUniqueKey<T>(keySet, item.children);
    if (found != null) {
      return found;
    }
  }
  return null;
}
