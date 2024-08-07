import 'package:flutter/cupertino.dart';

class FutureTriple<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext, AsyncSnapshot<T>) data;
  final Widget error;
  final Widget loading;

  const FutureTriple({
    super.key,
    required this.future,
    required this.data,
    required this.error,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return data(context, snapshot);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return loading;
        } else if (snapshot.hasError) {
          return error;
        } else {
          return loading;
        }
      },
    );
  }
}
