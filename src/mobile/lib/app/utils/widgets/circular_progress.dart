import 'package:curved_progress_bar/curved_progress_bar.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double? width;
  final double? height;

  const CircularProgress({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width ?? 50,
        height: height ?? 50,
        child: CurvedCircularProgressIndicator(
          color: Theme.of(context).primaryTextTheme.displaySmall!.color,
        ),
      ),
    );
  }
}
