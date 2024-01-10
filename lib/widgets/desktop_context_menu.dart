import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DesktopContextMenu extends StatefulWidget {
  const DesktopContextMenu({
    super.key,
    required this.anchor,
    required this.menuChildren,
    this.onHide,
    this.upperChild,
  });

  final Offset anchor;
  final List<Widget> menuChildren;
  final Widget? upperChild;
  final VoidCallback? onHide;

  @override
  State<DesktopContextMenu> createState() => _DesktopContextMenuState();
}

class _DesktopContextMenuState extends State<DesktopContextMenu> {
  final GlobalKey _menuKey = GlobalKey();
  Offset? menuPosition;

  @override
  void initState() {
    super.initState();
    // Post-frame callback to set the position
    WidgetsBinding.instance.addPostFrameCallback((_) => _setMenuPosition());
  }

  void _setMenuPosition() {
    if (_menuKey.currentContext == null) {
      return;
    }
    final menuRenderBox =
        _menuKey.currentContext!.findRenderObject()! as RenderBox;
    final menuSize = menuRenderBox.size;

    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Calculate the position
    var left = widget.anchor.dx;
    var top = widget.anchor.dy;

    // Adjust if the menu overflows on the right
    if (left + menuSize.width > screenSize.width) {
      left = screenSize.width - menuSize.width;
    }

    // Adjust if the menu overflows at the bottom
    if (top + menuSize.height > screenSize.height) {
      top = screenSize.height - menuSize.height;
    }

    setState(() {
      menuPosition = Offset(left, top);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                ContextMenuController.removeAny();
                widget.onHide?.call();
              },
              onSecondaryTap: () {
                ContextMenuController.removeAny();
                widget.onHide?.call();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: menuPosition?.dy ?? widget.anchor.dy,
            left: menuPosition?.dx ?? widget.anchor.dx,
            child: Visibility(
              visible: menuPosition != null,
              maintainAnimation: true,
              maintainState: true,
              maintainSize: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                key: _menuKey,
                children: [
                  if (widget.upperChild != null) ...[
                    widget.upperChild!.animate().scaleXY(
                          duration: const Duration(milliseconds: 130),
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 8),
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                    child: _BuildMenu(
                      menuChildren: widget.menuChildren,
                    ),
                  ).animate().scaleXY(
                        delay: 50.milliseconds,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildMenu extends StatelessWidget {
  const _BuildMenu({
    required this.menuChildren,
  });

  final List<Widget> menuChildren;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 130,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...menuChildren,
          ],
        ),
      ),
    );
  }
}

class DesktopMenuItem extends StatelessWidget {
  const DesktopMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          ContextMenuController.removeAny();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 15,
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: color ?? Colors.white),
              const SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: const TextStyle().copyWith(
                  color: color ?? Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
