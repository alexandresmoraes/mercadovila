import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
                  "Agradecemos por escolher o VilaSESMO! É uma satisfação saber que você fez uma compra conosco.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.labelSmall!.copyWith(color: Colors.white, letterSpacing: 0.0),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(10)),
              //     color: Colors.white,
              //   ),
              //   margin: EdgeInsets.only(top: 40, left: 20, right: 20),
              //   height: 50,
              //   width: MediaQuery.of(context).size.width,
              //   child: TextButton(
              //       onPressed: () {
              //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrackOrderScreen(a: widget.analytics, o: widget.observer)));
              //       },
              //       child: Text('${AppLocalizations.of(context)!.btn_track_order}',
              //           style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold))),
              // ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
                onPressed: () {
                  Modular.to.pushReplacementNamed(TabModule.routeName);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Voltar',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        MdiIcons.arrowRight,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
