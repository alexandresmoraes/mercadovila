import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/modules/tab/tab_module.dart';

class CarrinhoSuccessPage extends StatefulWidget {
  final String title;
  const CarrinhoSuccessPage({Key? key, this.title = 'Compra sucesso'}) : super(key: key);
  @override
  CarrinhoSuccessPageState createState() => CarrinhoSuccessPageState();
}

class CarrinhoSuccessPageState extends State<CarrinhoSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Modular.to.pushReplacementNamed(TabModule.routeName);
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/orderSuccessScreen.png'),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.44,
              ),
              Text(
                "Parabéns!",
                style: Theme.of(context).primaryTextTheme.displaySmall!.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  "Obrigado por sua compra! Valorizamos sua escolha e esperamos que você aproveite sua experiência. Tenha um ótimo dia!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.labelSmall!.copyWith(color: Colors.white, letterSpacing: 0.0),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () {
                      Modular.to.pushReplacementNamed(TabModule.routeName);
                    },
                    child: const Text('Voltar', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
