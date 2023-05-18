import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  final String title;
  const OrderDetailPage({Key? key, this.title = 'OrderDetailPage'}) : super(key: key);
  @override
  OrderDetailPageState createState() => OrderDetailPageState();
}
class OrderDetailPageState extends State<OrderDetailPage> {
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