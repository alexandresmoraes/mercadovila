import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key? key, this.title = 'LoginPage'}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // exitAppDialog();
        return false;
      },
      child: Scaffold(
          body: Container(
        decoration: 1 == 1
            ? const BoxDecoration(
                gradient: LinearGradient(
                  stops: [0, 0.65],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF50546F), Color(0xFF8085A3)],
                ),
              )
            : BoxDecoration(
                gradient: LinearGradient(
                  stops: const [0, 0.65],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                ),
              ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height * 0.50,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/login_signup.png'),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              right: null,
              child: IconButton(
                onPressed: () {
                  // exitAppDialog();
                },
                icon: const Icon(MdiIcons.arrowLeft, color: Colors.white),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.07,
              // left: MediaQuery.of(context).size.width / 4,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.displaySmall,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 35),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(40))),
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45 - 20),
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Username', style: Theme.of(context).primaryTextTheme.bodyLarge),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 20),
                      child: Text('Cód Verificação', style: Theme.of(context).primaryTextTheme.bodyLarge),
                    ),
                    Container(
                      height: 50,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                      padding: const EdgeInsets.only(),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          prefixIcon: Icon(
                            Icons.account_box_sharp,
                            color: Theme.of(context).inputDecorationTheme.hintStyle!.color,
                          ),
                          counterText: '',
                          contentPadding: const EdgeInsets.only(top: 10),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                              stops: const [0, .90],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor])),
                      margin: const EdgeInsets.only(top: 20),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                          onPressed: () {
                            // Navigator.of(context)
                            //     .push(MaterialPageRoute(builder: (context) => OtpVerificationScreen(a: widget.analytics, o: widget.observer)));
                          },
                          child: const Text('Login')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              thickness: 2,
                            ),
                          ),
                          Text('  Login  ', style: Theme.of(context).primaryTextTheme.bodyLarge),
                          Expanded(
                              child: Divider(
                            color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                            thickness: 2,
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                                color: Color(0xFFEC5F60),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(45),
                                )),
                            alignment: Alignment.center,
                            child: Icon(
                              FontAwesomeIcons.google,
                              size: 25,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          Container(
                            height: 45,
                            width: 45,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            decoration: const BoxDecoration(
                                color: Color(0xFF4C87D0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(45),
                                )),
                            alignment: Alignment.center,
                            child: Icon(
                              FontAwesomeIcons.facebookF,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isloading = true;

  @override
  void initState() {
    super.initState();
  }
}
