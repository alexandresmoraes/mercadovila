import 'package:flutter/material.dart';

class PedidosPage extends StatefulWidget {
  final String title;
  const PedidosPage({Key? key, this.title = 'PedidosPage'}) : super(key: key);
  @override
  PedidosPageState createState() => PedidosPageState();
}
class PedidosPageState extends State<PedidosPage> {
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