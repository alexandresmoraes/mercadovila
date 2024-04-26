import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardProdutoColorLoading extends StatelessWidget {
  const CardProdutoColorLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 145,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Shimmer.fromColors(
            baseColor: index % 3 == 1
                ? const Color(0XFF9EEEFF)
                : index % 3 == 2
                    ? const Color(0XFFFFF1C0)
                    : const Color(0XFFFFD4D7),
            highlightColor: Colors.white,
            child: Container(
              height: 210,
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 160,
                    width: 140,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(17),
                        bottomLeft: Radius.circular(17),
                        bottomRight: Radius.circular(17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
