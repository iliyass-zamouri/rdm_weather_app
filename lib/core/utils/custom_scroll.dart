import 'package:flutter/material.dart';

/// Custom scroll behavior to remove overscroll glow
class CustomScroll extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
