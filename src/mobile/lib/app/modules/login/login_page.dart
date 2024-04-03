import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/modules/login/login_controller.dart';
import 'package:vilasesmo/app/modules/tab/tab_module.dart';
import 'package:vilasesmo/app/stores/account_store.dart';
import 'package:vilasesmo/app/utils/models/login_model.dart';
import 'package:vilasesmo/app/utils/services/interfaces/i_auth_service.dart';
import 'package:vilasesmo/app/utils/widgets/circular_progress.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key? key, this.title = 'Login'}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _controller = Modular.get<LoginController>();

  final passwordFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();

  String animationType = 'idle';

  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        setState(() {
          animationType = 'hands_up';
        });
      }
    });

    usernameFocusNode.addListener(() {
      if (usernameFocusNode.hasFocus && animationType == 'hands_up') {
        setState(() {
          animationType = 'hands_down';
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: Stack(
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
          !kIsWeb
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.43,
                  width: MediaQuery.of(context).size.width,
                  child: FlareActor(
                    'assets/Teddy.flr',
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.contain,
                    animation: animationType,
                    callback: (animation) {},
                  ),
                )
              : const SizedBox.shrink(),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 35),
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(40))),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45 - 20),
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                    padding: const EdgeInsets.only(),
                    child: TextFormField(
                      focusNode: usernameFocusNode,
                      textInputAction: TextInputAction.done,
                      maxLength: 10,
                      onChanged: _controller.setUsername,
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Nome de usuário ou email',
                        prefixIcon: Icon(
                          MdiIcons.account,
                          color: Theme.of(context).inputDecorationTheme.hintStyle!.color,
                        ),
                        counterText: '',
                        contentPadding: const EdgeInsets.only(top: 10),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                    padding: const EdgeInsets.only(),
                    margin: const EdgeInsets.only(top: 20),
                    child: Observer(builder: (_) {
                      return TextFormField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        obscureText: !_controller.isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        maxLength: 10,
                        onChanged: _controller.setPassword,
                        style: Theme.of(context).primaryTextTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          prefixIcon: Icon(
                            Icons.password,
                            color: Theme.of(context).inputDecorationTheme.hintStyle!.color,
                          ),
                          counterText: '',
                          contentPadding: const EdgeInsets.only(top: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _controller.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              color: Theme.of(context).inputDecorationTheme.hintStyle!.color,
                            ),
                            onPressed: () {
                              _controller.isPasswordVisible = !_controller.isPasswordVisible;
                            },
                          ),
                        ),
                      );
                    }),
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
                        onPressed: () async {
                          try {
                            setState(() {
                              animationType = 'hands_down';
                              isLoading = true;
                            });

                            var authService = Modular.get<IAuthService>();

                            var result = await authService.login(LoginModel(
                              usernameOrEmail: _controller.username!,
                              password: _controller.password,
                            ));

                            await result.fold((resultFail) {
                              var message = resultFail.getErrorNotProperty();
                              if (message.isNotEmpty) GlobalSnackbar.error(message);

                              setState(() {
                                animationType = 'fail';
                              });
                            }, (r) async {
                              setState(() {
                                animationType = 'success';
                              });

                              await Future.delayed(const Duration(seconds: 2));

                              await authService.setCurrentToken(r);
                              Modular.get<CarrinhoStore>().load();
                              Modular.get<AccountStore>().setAccount(await authService.me());
                              Modular.to.pushReplacementNamed(TabModule.routeName);
                            });
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: isLoading
                            ? const CircularProgress(
                                width: 21,
                                height: 21,
                              )
                            : const Text('Entrar')),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
