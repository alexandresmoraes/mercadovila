import 'package:flutter/material.dart';

class MinhasComprasPage extends StatefulWidget {
  final String title;
  const MinhasComprasPage({Key? key, this.title = 'MinhasComprasPage'}) : super(key: key);
  @override
  MinhasComprasPageState createState() => MinhasComprasPageState();
}
class MinhasComprasPageState extends State<MinhasComprasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}