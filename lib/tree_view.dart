import 'package:flutter/material.dart';

import '_debug.dart';
import 'node.dart';
import 'tree_node.dart';
import 'tree_view_controller.dart';
import 'tree_view_theme.dart';

/// Supported node selection behaviors.
enum SelectionMode {
  /// Indicates that the tree doesn't allow node selection.
  none,

  /// Indicates that the tree allows single selection.
  single,

  /// Indicates that the tree allows multiple selection.
  multiple,
}

class TreeView<T> extends StatefulWidget {
  /// The controller for the [TreeView]. It manages the data and selected key.
  late final TreeViewController<T> controller;

  /// The padding of the widget.
  final EdgeInsets? padding;

  /// The tap handler for a node. Passes the node key.
  final ValueChanged<Key>? onNodeTap;

  /// The double tap handler for a node. Passes the node key.
  final void Function(Key, TapUpDetails)? onNodeSecondaryTapUp;

  /// The expand/collapse handler for a node. Passes the node key and the
  /// expansion state.
  final void Function(Key, bool)? onExpansionChanged;

  /// Custom builder for nodes. Parameters are the build context and tree node.
  final Widget Function(BuildContext, Node<T>)? nodeBuilder;

  /// The theme for [TreeView].
  final TreeViewTheme? theme;

  /// Determines whether the user can select a parent node. If false,
  /// tapping the parent will expand or collapse the node. If true, the node
  /// will be selected and the use has to use the expander to expand or
  /// collapse the node.
  final bool allowParentSelect;

  /// How the [TreeView] should respond to user input.
  final ScrollPhysics? physics;

  /// Whether the extent of the [TreeView] should be determined by the contents
  /// being viewed.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// Whether the [TreeView] is the primary scroll widget associated with the
  /// parent PrimaryScrollController..
  ///
  /// Defaults to true.
  final bool primary;

  /// Determines whether the parent node can receive a double tap. This is
  /// useful if [allowParentSelect] is true. This allows the user to double tap
  /// the parent node to expand or collapse the parent when [allowParentSelect]
  /// is true.
  /// ___IMPORTANT___
  /// _When true, the tap handler is delayed. This is because the double tap
  /// action requires a short delay to determine whether the user is attempting
  /// a single or double tap._
  final bool supportParentDoubleTap;

  /// Indention size.
  final double indent;

  /// Specifies the empty placeholder widget to render if the tree is currently empty.
  final Widget? empty;

  TreeView({
    Key? key,
    TreeViewController<T>? controller,
    this.onNodeTap,
    this.onNodeSecondaryTapUp,
    this.onExpansionChanged,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.allowParentSelect = false,
    this.supportParentDoubleTap = false,
    this.shrinkWrap = false,
    this.theme = const TreeViewTheme.fallback(),
    this.primary = true,
    this.indent = 20,
    this.nodeBuilder,
    this.empty,
  })  :
        // assert(selectionMode == SelectionMode.single && selectedNodes.length < 2),
        controller = controller ?? TreeViewController(),
        assert(!debugNodesHaveDuplicateKeys<T>(controller!.nodes)),
        super(key: key);

  @override
  State<TreeView<T>> createState() => _TreeViewState<T>();

  static _TreeViewState<T> of<T>(BuildContext context, {bool build = true}) {
    return build
        ? context.dependOnInheritedWidgetOfExactType<_TreeViewScope<T>>()!.state
        : context.findAncestorWidgetOfExactType<_TreeViewScope<T>>()!.state;
  }
}

class _TreeViewState<T> extends State<TreeView<T>> {
  late TreeViewController<T> _controller;

  List<Node<T>> get nodes => _controller.nodes;
  Set<Key> get selectedNodes => _controller.selectedNodes;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  void _handleTap(Node<T> node) {
    _controller.touchNode(node.key);
    widget.onNodeTap?.call(node.key);
    setState(() {});
  }

  void _handleSecondaryTapUp(Node<T> node, TapUpDetails details) {
    widget.onNodeSecondaryTapUp?.call(node.key, details);
  }

  void _handleExpansionChanged(Node<T> node, bool expanded) {
    widget.onExpansionChanged?.call(node.key, expanded);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.empty ?? const SizedBox.shrink();
    if (nodes.isNotEmpty) {
      child = ListView.builder(
        shrinkWrap: widget.shrinkWrap,
        padding: widget.padding,
        primary: widget.primary,
        physics: widget.physics,
        itemCount: nodes.length,
        itemBuilder: (context, index) {
          final child = nodes[index];
          final selected =
              TreeView.of<T>(context).selectedNodes.contains(child.key);

          return TreeNode<T>(
            key: child.key,
            node: child,
            selected: selected,
            onTap: _handleTap,
            onSecondaryTapUp: _handleSecondaryTapUp,
            onExpansionChanged: _handleExpansionChanged,
          );
        },
      );
    }

    return _TreeViewScope(state: this, child: child);
  }
}

class _TreeViewScope<T> extends InheritedWidget {
  final _TreeViewState<T> state;

  const _TreeViewScope({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return key != oldWidget.key || child != oldWidget.child;
  }
}
