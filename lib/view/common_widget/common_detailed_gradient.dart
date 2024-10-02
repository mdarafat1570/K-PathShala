import 'package:flutter/material.dart';

class GradientBackgroundDetailed extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;

  const GradientBackgroundDetailed({
    required this.child,
    required this.colors, // Default colors
    this.begin = Alignment.topLeft, // Default start alignment
    this.end = Alignment.bottomRight, // Default end alignment
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}
