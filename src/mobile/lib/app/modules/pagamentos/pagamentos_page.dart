import 'package:flutter/material.dart';

class PagamentosPage extends StatefulWidget {
  final String title;
  const PagamentosPage({Key? key, this.title = 'PagamentosPage'}) : super(key: key);
  @override
  PagamentosPageState createState() => PagamentosPageState();
}
class PagamentosPageState extends State<PagamentosPage> {
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