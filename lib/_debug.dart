import 'dart:collection';

import 'package:flutter/material.dart';

import 'node.dart';

bool debugNodesHaveDuplicateKeys<T>(Iterable<Node<T>> items) {
  assert(() {
    final Key? nonUniqueKey = _firstNonUniqueKey<T>(items);
    if (nonUniqueKey != null) {
      throw FlutterError('Duplicate key found: $nonUniqueKey.');
    }
    return true;
  }());
  return false;
}

final Set<Key> keySet = HashSet<Key>();

Key? _firstNonUniqueKey<T>(Iterable<Node<T>> nodes) {
  for (final Node<T> node in nodes) {
    if (!keySet.add(node.key)) {
      return node.key;
    }

    final found = _firstNonUniqueKey<T>(node.children);
    if (found != null) {
      return found;
    }
  }
  return null;
}
