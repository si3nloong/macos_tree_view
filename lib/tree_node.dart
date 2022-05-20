import 'dart:math';

import 'package:flutter/material.dart';

import 'macos_tree_view.dart';

class TreeNode<T> extends StatefulWidget {
  /// The node object used to display the widget state.
  final Node<T> node;

  /// The node nested level.
  final int level;

  /// Determine the node is selected or not.
  final bool selected;

  /// The tap function.
  final void Function(Node<T> node)? onTap;

  /// The secondary tap up function.
  final void Function(Node<T> node, TapUpDetails details)? onSecondaryTapUp;

  /// The expansion function.
  final void Function(Node<T> node, bool expanded)? onExpansionChanged;

  const TreeNode({
    Key? key,
    required this.node,
    this.selected = false,
    this.level = 0,
    this.onTap,
    this.onSecondaryTapUp,
    this.onExpansionChanged,
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

  late bool _isExpanded;

  final double _height = 25;
  final double _width = 20;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = _controller.drive(_easeInTween);
    _isExpanded = widget.node.expanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildExpander() {
    return GestureDetector(
      onTap: () {
        if (_isExpanded) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
        _isExpanded = !_isExpanded;
        widget.onExpansionChanged?.call(widget.node, _isExpanded);
      },
      child: Container(
        width: _width,
        height: _height,
        alignment: AlignmentDirectional.centerEnd,
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
    final builder = TreeView.of<T>(context).widget.nodeBuilder;
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
    final boxSize = widget.level * TreeView.of<T>(context).widget.indent;

    return Column(
      children: [
        Container(
          height: _height,
          width: double.infinity,
          decoration: BoxDecoration(
            color:
                widget.selected ? theme.primaryColor.withOpacity(0.65) : null,
            borderRadius: BorderRadius.circular(5),
          ),
          child: GestureDetector(
            onTap: () {
              widget.onTap?.call(widget.node);
            },
            onSecondaryTapUp: (details) {
              widget.onSecondaryTapUp?.call(widget.node, details);
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
              final selected =
                  TreeView.of<T>(context).selectedNodes.contains(child.key);

              return TreeNode<T>(
                key: child.key,
                node: child,
                selected: selected,
                level: widget.level + 1,
                onTap: widget.onTap,
                onSecondaryTapUp: widget.onSecondaryTapUp,
                onExpansionChanged: widget.onExpansionChanged,
              );
            },
          ),
        ),
      ],
    );
  }
}
