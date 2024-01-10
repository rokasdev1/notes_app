import 'package:flutter/material.dart';

import 'desktop_context_menu.dart';

class DesktopPopUp extends StatefulWidget {
  const DesktopPopUp({
    super.key,
    required this.child,
    required this.menuChildren,
  });

  final Widget child;
  final List<Widget> menuChildren;

  @override
  State<DesktopPopUp> createState() => _DesktopPopUpState();
}

class _DesktopPopUpState extends State<DesktopPopUp> {
  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenuBuilder: (context, offset) {
        return DesktopContextMenu(
          anchor: offset,
          menuChildren: widget.menuChildren,
        );
      },
      child: widget.child,
    );
  }
}

class DesktopPopUpItem extends StatelessWidget {
  Widget child;
  DesktopPopUpItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

typedef ContextMenuBuilder = Widget Function(
  BuildContext context,
  Offset offset,
);

/// Shows and hides the context menu based on user gestures.
///
/// By default, shows the menu on right clicks and long presses.
class ContextMenuRegion extends StatefulWidget {
  /// Creates an instance of [ContextMenuRegion].
  const ContextMenuRegion({
    super.key,
    required this.child,
    required this.contextMenuBuilder,
    this.onShow,
    this.onHide,
  });

  /// Builds the context menu.
  final ContextMenuBuilder contextMenuBuilder;
  final VoidCallback? onShow;
  final VoidCallback? onHide;

  /// The child widget that will be listened to for gestures.
  final Widget child;

  @override
  State<ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<ContextMenuRegion> {
  final ContextMenuController _contextMenuController = ContextMenuController();

  void _onTap(TapUpDetails details) {
    if (!_contextMenuController.isShown) {
      _show(details.globalPosition);
      return;
    }
    _hide();
  }

  void _show(Offset position) {
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
    widget.onShow?.call();
  }

  void _hide() {
    _contextMenuController.remove();
    widget.onHide?.call();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const OvalBorder(),
      onTapUp: _onTap,
      child: widget.child,
    );
  }
}
