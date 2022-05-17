import 'package:flutter/material.dart';

import 'node.dart';
import 'tree_node.dart';
import 'tree_view_controller.dart';

class TreeView<T> extends StatelessWidget {
  /// The controller for the [TreeView]. It manages the data and selected key.
  late final TreeViewController<T> controller;

  final EdgeInsets? padding;

  /// The key of the selected node;
  final Key? selected;

  /// The tap handler for a node. Passes the node key.
  final ValueChanged<String>? onNodeTap;

  /// The double tap handler for a node. Passes the node key.
  final void Function(TapUpDetails, String)? onNodeSecondaryTapUp;

  /// The expand/collapse handler for a node. Passes the node key and the
  /// expansion state.
  final void Function(String, bool)? onExpansionChanged;

  /// Custom builder for nodes. Parameters are the build context and tree node.
  final Widget Function(BuildContext, Node<T>)? nodeBuilder;

  /// The theme for [TreeView].
  // final TreeViewTheme theme;

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

  TreeView({
    Key? key,
    TreeViewController<T>? controller,
    this.selected,
    this.onNodeTap,
    this.onNodeSecondaryTapUp,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.onExpansionChanged,
    this.allowParentSelect = false,
    this.supportParentDoubleTap = false,
    this.shrinkWrap = false,
    this.primary = true,
    this.nodeBuilder,
  })  : controller = controller ?? TreeViewController(),
        super(key: key);
  // assert(KeyedSubtree.ensureUniqueKeysForList(widget.children))

  static TreeView<T> of<T>(BuildContext context, {bool build = true}) {
    return build
        ? context.dependOnInheritedWidgetOfExactType<_TreeViewScope<T>>()!.state
        : context.findAncestorWidgetOfExactType<_TreeViewScope<T>>()!.state;
  }

  // static TreeView<T> of<T>(BuildContext context) {
  //   final _TreeViewScope<T> scope =
  //       context.dependOnInheritedWidgetOfExactType<_TreeViewScope<T>>()!;
  //   return scope.widget;
  // }

  @override
  Widget build(BuildContext context) {
    final nodes = controller.nodes.toList();

    return _TreeViewScope(
      state: this,
      child: ListView.builder(
        shrinkWrap: shrinkWrap,
        padding: padding,
        primary: primary,
        physics: physics,
        itemCount: nodes.length,
        itemBuilder: (context, index) {
          final child = nodes[index];

          return TreeNode<T>(
            key: ValueKey(child.key),
            node: child,
          );
        },
      ),
    );
  }
}

// class _TreeViewState<T> extends State<TreeView<T>> {
//   late TreeViewController<T> _controller;
//   // late List<Widget> _childrenWithKey;

//   @override
//   void initState() {
//     super.initState();
//     // _updateTreeViewController();
//     // _controller.addListener(() {
//     //   print(_controller.nodes);
//     // });
//     // _childrenWithKey = KeyedSubtree.ensureUniqueKeysForList([]);
//     _controller = widget.controller ?? TreeViewController<T>();
//   }

//   void _updateTreeViewController() {
//     // final TreeViewController<T> newController =
//     //     widget.controller ?? TreeView.of<T>(context);
//     // if (newController == _controller) {
//     //   return;
//     // }

//     // if (_controllerIsValid) {
//     //   _controller.animation!.removeListener(_handleTabControllerAnimationTick);
//     // }
//     // _controller = newController;

//     setState(() {});
//     // _controller.animation!.addListener(_handleTabControllerAnimationTick);
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _updateTreeViewController();
//   }

//   @override
//   void didUpdateWidget(TreeView<T> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _updateTreeViewController();
//   }

//   @override
//   void dispose() {
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }
// }

class _TreeViewScope<T> extends InheritedWidget {
  final TreeView<T> state;

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
