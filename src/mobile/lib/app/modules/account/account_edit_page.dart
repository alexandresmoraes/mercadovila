import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class AccountEditPage extends StatefulWidget {
  final String title;
  const AccountEditPage({Key? key, this.title = 'AccountEditPage'}) : super(key: key);
  @override
  AccountEditPageState createState() => AccountEditPageState();
}

class AccountEditPageState extends State<AccountEditPage> {
  final _cName = TextEditingController();
  final _cNameOnCard = TextEditingController();
  final _cEmail = TextEditingController();
  final _cGender = TextEditingController();
  final _fName = FocusNode();

  final _fNameOnCard = FocusNode();
  final _fEmail = FocusNode();
  final _fGender = FocusNode();
  AccountEditPageState() : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Modular.get<ThemeStore>().isDarkModeEnable ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).inputDecorationTheme.fillColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Editar conta de usuário"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 240,
              color: Colors.transparent,
              alignment: Alignment.topCenter,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 240,
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/profile_edit.png'),
                        ),
                      ),
                      alignment: Alignment.topCenter,
                      child: const Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 53,
                            backgroundImage: AssetImage('assets/person.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Trocar foto',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nome de usuário",
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.only(),
                        child: TextFormField(
                          controller: _cName,
                          focusNode: _fName,
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                          decoration: InputDecoration(
                            fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                ? Theme.of(context).inputDecorationTheme.fillColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            hintText: 'Alexandre Moraes',
                            contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                      Text(
                        "Telefone",
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.only(),
                        child: TextFormField(
                          controller: _cNameOnCard,
                          focusNode: _fNameOnCard,
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                          decoration: InputDecoration(
                            fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                ? Theme.of(context).inputDecorationTheme.fillColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            hintText: '+55 46999055421',
                            contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                      Text(
                        "Email",
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.only(),
                        child: TextFormField(
                          controller: _cEmail,
                          focusNode: _fEmail,
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                          decoration: InputDecoration(
                            fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                ? Theme.of(context).inputDecorationTheme.fillColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            hintText: 'alexandresmoraes@me.com',
                            contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                      Text(
                        "Gênero",
                        style: Theme.of(context).primaryTextTheme.displayMedium,
                      ),
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.only(),
                        child: TextFormField(
                          controller: _cGender,
                          focusNode: _fGender,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                          decoration: InputDecoration(
                            fillColor: Modular.get<ThemeStore>().isDarkModeEnable
                                ? Theme.of(context).inputDecorationTheme.fillColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            hintText: 'Masculino',
                            counterText: '',
                            contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    stops: const [0, .90],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
                  ),
                ),
                margin: const EdgeInsets.all(8.0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Salvar')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
