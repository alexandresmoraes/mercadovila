import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccountPage extends StatefulWidget {
  final String title;
  const AccountPage({Key? key, this.title = 'AccountHomePage'}) : super(key: key);
  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(45),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor],
            ),
          ),
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
                      image: AssetImage('assets/myprofile.png'),
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  child: const Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 53,
                        backgroundImage: AssetImage('assets/person.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 45,
                child: Text(
                  "Daniela Escober",
                  style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 25,
                child: Text(
                  "+91 9007210595 | d.escober@gmail.com",
                  style: Theme.of(context).primaryTextTheme.displayMedium!.copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: -20,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfileEditScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40),
                      ),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Image.asset('assets/edit.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => OrderListScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.shoppingOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Text(
                    "Minhas compras",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => AddressListScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.mapMarkerOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Text(
                    "Endereços",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => WalletScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.walletOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Text(
                    "Carteira",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => WishListScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.heartOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Text(
                    "Favoritos",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => NotificationScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.bellOutline,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Text(
                    "Notificações",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => MemberShipScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.walletMembership,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Text(
                    "Recompensa",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => RewardScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.walletMembership,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                    size: 20,
                  ),
                  title: Text(
                    "Cupons",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ReferAndEarnScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.accountConvert,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                  ),
                  title: Text(
                    "Programa fidelidade",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ChooseLanguageScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.translate,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                  ),
                  title: Text(
                    "Idioma",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    // global.isDarkModeEnable = !global.isDarkModeEnable;
                    // Phoenix.rebirth(context);
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: 1 == 1 // TODO
                      ? Icon(
                          Icons.dark_mode_outlined,
                          color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                        )
                      : Icon(
                          Icons.light_mode,
                          color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                        ),
                  title: Text(
                    "Tema",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ContactUsScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    Icons.feedback_outlined,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                  ),
                  title: Text(
                    "Contato",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.textBox,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                  ),
                  title: Text(
                    "Sobre nós",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => SettingScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.cogOutline,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                  ),
                  title: Text(
                    "Configurações",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => LogInScreen(a: widget.analytics, o: widget.observer),
                    //   ),
                    // );
                  },
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    MdiIcons.logout,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color!.withOpacity(0.7),
                  ),
                  title: Text(
                    "Sair",
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                  ),
                ),
                const SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        ))
      ],
    ));
  }
}
