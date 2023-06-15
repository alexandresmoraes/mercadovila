import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final void Function()? onTap;

  const RefreshButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            stops: const [0, .90],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
          ),
        ),
        height: 50,
        child: GestureDetector(
          onTap: onTap,
          child: Icon(
            Icons.refresh,
            size: 50,
            color: Theme.of(context).primaryTextTheme.displaySmall!.color,
          ),
        ),
      ),
    );
  }
}
