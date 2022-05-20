import 'dart:collection';

import 'package:flutter/material.dart';

import 'node.dart';

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

Key? _firstNonUniqueKey<T>(Set<Key> keySet, Iterable<Node<T>> nodes) {
  for (final Node<T> node in nodes) {
    if (!keySet.add(node.key)) {
      return node.key;
    }

    final found = _firstNonUniqueKey<T>(keySet, node.children);
    if (found != null) {
      return found;
    }
  }
  return null;
}
