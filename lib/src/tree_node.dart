import 'dart:math';

import 'package:flutter/material.dart';

import 'tree_view.dart';
import 'tree_view_controller.dart';

class TreeNode<T> extends StatefulWidget {
  /// The node object used to display the widget state.
  final Node<T> node;

  const TreeNode({
    Key? key,
    required this.node,
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

  final double _height = 25;
  final double _width = 20;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = _controller.drive(_easeInTween);
    if (widget.node.expanded) {
      _controller.value = 1.0;
    }
    widget.node.addListener(_updateAnimation);
  }

  void _updateAnimation() {
    if (widget.node.expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    widget.node.removeListener(_updateAnimation);
    _controller.dispose();
    super.dispose();
  }

  Widget _buildExpander() {
    return GestureDetector(
      onTap: () {
        widget.node.toggleExpand();
        TreeView.of<T>(context)
            .handleExpansionChanged(widget.node, widget.node.expanded);
      },
      child: Container(
        width: _width,
        height: _height,
        alignment: AlignmentDirectional.centerEnd,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            child: Icon(Icons.arrow_forward_ios_rounded,
                size: TreeView.of<T>(context).widget.iconSize,
                color: widget.node.iconColor),
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
    final builder = TreeView.of<T>(context).widget.nodeBuilder;
    if (builder != null) {
      return builder(context, widget.node);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        widget.node.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final boxSize = widget.node.depth * TreeView.of<T>(context).widget.indent;

    return Column(
      children: [
        AnimatedBuilder(
          animation: widget.node,
          builder: (context, child) {
            return Container(
              height: _height,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    widget.node.selected ? widget.node.selectedIconColor : null,
                borderRadius: BorderRadius.circular(5),
              ),
              child: child,
            );
          },
          child: GestureDetector(
            onTap: () {
              TreeView.of<T>(context).handleTap(widget.node);
            },
            onSecondaryTapUp: (details) {
              TreeView.of<T>(context)
                  .handleSecondaryTapUp(widget.node, details);
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
          animation: widget.node,
          builder: (context, child) {
            /// If it's not expanded, we can lazy load it
            /// to improve the performance
            if (!widget.node.expanded && _animation.value <= 0) {
              return const SizedBox.shrink();
            }

            return AnimatedBuilder(
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
                    key: child.key,
                    node: child,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
