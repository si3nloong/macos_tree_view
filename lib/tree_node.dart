import 'dart:math';

import 'package:flutter/material.dart';

import 'macos_tree_view.dart';

class TreeNode<T> extends StatefulWidget {
  /// The node object used to display the widget state
  final Node<T> node;

  /// The node nested level
  final int level;

  const TreeNode({
    Key? key,
    required this.node,
    this.level = 0,
  }) : super(key: key);

  @override
  State<TreeNode<T>> createState() => _TreeNodeState<T>();
}

class _TreeNodeState<T> extends State<TreeNode<T>>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isExpanded = false;

  final double _height = 25;
  final double _width = 20;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = _controller.drive(_easeInTween);
    _isExpanded = widget.node.expanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
    // final TreeView<T>? treeView = TreeView.of<T>(context);
    // assert(treeView != null, 'TreeView must exist in context');
    // _isSelected = widget.node.key == _treeView!.controller.selectedKey;
    _controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          setState(() {
            _isExpanded = true;
          });
          break;

        case AnimationStatus.dismissed:
          setState(() {
            _isExpanded = false;
          });
          break;

        default:
          setState(() {});
          break;
      }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   TreeView? _treeView = TreeView.of(context);
  //   // _controller.duration = _treeView!.theme.expandSpeed;
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(TreeNode oldWidget) {
  //   // print(oldWidget);
  //   // if (widget.node.expanded != oldWidget.node.expanded) {
  //   //   setState(() {
  //   //     _isExpanded = widget.node.expanded;
  //   //     if (_isExpanded) {
  //   //       _controller.forward();
  //   //     } else {
  //   //       _controller.reverse().then<void>((void value) {
  //   //         if (!mounted) return;
  //   //         setState(() {});
  //   //       });
  //   //     }
  //   //   });
  //   // } else if (widget.node != oldWidget.node) {
  //   //   setState(() {});
  //   // }
  //   // super.didUpdateWidget(oldWidget);
  // }

  Widget _buildExpander() {
    return GestureDetector(
      onTap: () {
        if (_isExpanded) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
        _isExpanded = !_isExpanded;
        TreeView.of<T>(context)
            .onExpansionChanged
            ?.call(widget.node.key, !_isExpanded);
      },
      child: Container(
        width: _width,
        height: _height,
        alignment: AlignmentDirectional.centerEnd,
        // color: Colors.orange,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            child: const Icon(Icons.arrow_forward_ios_rounded, size: 11),
            builder: (_, child) {
              return Transform.rotate(
                angle: _animation.value * 90 * (pi / 180),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    final builder = TreeView.of<T>(context).nodeBuilder;
    if (builder != null) {
      return builder(context, widget.node);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        widget.node.label,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected =
        widget.node.key == TreeView.of<T>(context).controller.selected;
    final boxSize = widget.level * _width;

    return Column(
      children: [
        Container(
          height: _height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: selected ? theme.primaryColor.withOpacity(0.65) : null,
            borderRadius: BorderRadius.circular(5),
          ),
          child: GestureDetector(
            onTap: () {
              TreeView.of<T>(context).onNodeTap?.call(widget.node.key);
            },
            onSecondaryTapUp: (details) {
              TreeView.of<T>(context)
                  .onNodeSecondaryTapUp
                  ?.call(details, widget.node.key);
            },
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                if (boxSize <= 0)
                  const SizedBox.shrink()
                else
                  Container(width: boxSize),
                _buildExpander(),
                Expanded(child: _buildLabel()),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                heightFactor: _animation.value,
                child: child,
              ),
            );
          },
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.node.children.length,
            itemBuilder: (context, index) {
              final child = widget.node.children[index];

              return TreeNode<T>(
                key: ValueKey(child.key),
                node: child,
                level: widget.level + 1,
              );
            },
            // onReorder: (a, b) {},
          ),
        ),
      ],
    );
  }
}
