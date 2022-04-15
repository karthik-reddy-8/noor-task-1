import 'package:flutter/material.dart';

/// Progress dialog is used to show progress in the application.
class ProgressDialog extends StatelessWidget {
  /// Creates a progress dialog.
  const ProgressDialog({
    Key? key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.8,
    this.color = Colors.white,
    this.valueColor,
  }) : super(key: key);

  /// [child] is the widget that will be displayed under the progress bar.
  final Widget child;

  /// [inAsyncCall] indicates whether the progress dialog is currently shown.
  final bool inAsyncCall;

  /// [opacity] is the opacity of the progress bar background.
  final double opacity;

  /// [color] is the color of the progress bar background.
  final Color color;

  /// [valueColor] is the color of the progress bar.
  final Animation<Color>? valueColor;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
