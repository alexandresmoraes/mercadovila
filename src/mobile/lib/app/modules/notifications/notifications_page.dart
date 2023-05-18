import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vilasesmo/app/stores/theme_store.dart';

class NotificationsPage extends StatefulWidget {
  final String title;
  const NotificationsPage({Key? key, this.title = 'NotificationsPage'}) : super(key: key);
  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationModel {
  String? title;
  String? imagePath;
  String? description;
  String? datetTime;

  NotificationModel({this.description, this.imagePath, this.datetTime, this.title});
}

class NotificationsPageState extends State<NotificationsPage> {
  NotificationsPageState() : super();
  List<NotificationModel> notificationList = [
    NotificationModel(
        title: "Order Placed Successfully",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/g_logo.png"),
    NotificationModel(
        title: "Super Sale is on",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/g_logo.png"),
    NotificationModel(
        title: "Flat discount", description: "Flat 20 discount on multiple products", datetTime: "10 min ago", imagePath: "assets/vegetables.png"),
    NotificationModel(
        title: "Became a Prime Member",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/cleaning.png"),
    NotificationModel(
        title: "Black Friday sale is back",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/g_logo.png"),
    NotificationModel(
        title: "Weekend Bonanza Deal",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/g_logo.png"),
    NotificationModel(
        title: "Order Placed Successfully",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/soap.png"),
    NotificationModel(
        title: "Super Sale is on",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/g_logo.png"),
    NotificationModel(
        title: "Flat discount", description: "Flat 20 discount on multiple products", datetTime: "10 min ago", imagePath: "assets/cleaning.png"),
    NotificationModel(
        title: "Became a Prime Member",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/g_logo.png"),
    NotificationModel(
        title: "Black Friday sale is back",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/soap.png"),
    NotificationModel(
        title: "Weekend Bonanza Deal",
        description: "Congratulation we received your order, rider is on its way",
        datetTime: "10 min ago",
        imagePath: "assets/vegetables.png"),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () {
              Modular.to.pop();
            },
            child: const Align(
              alignment: Alignment.center,
              child: Icon(MdiIcons.arrowLeft),
            ),
          ),
          centerTitle: true,
          title: const Text("Notificações"),
          actions: [
            IconButton(
              onPressed: () async {},
              icon: const Icon(MdiIcons.plus),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: notificationList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          image: AssetImage(notificationList[index].imagePath!),
                        ),
                      ),
                    ),
                    title: Text(
                      notificationList[index].title!,
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        text: "${notificationList[index].description}",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .labelSmall!
                            .copyWith(color: Theme.of(context).primaryTextTheme.labelSmall!.color!.withOpacity(0.6), letterSpacing: 0.1),
                        children: [
                          TextSpan(
                            text: '\n${notificationList[index].datetTime}',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .labelLarge!
                                .copyWith(color: Theme.of(context).primaryTextTheme.labelLarge!.color!.withOpacity(0.4)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Modular.get<ThemeStore>().isDarkModeEnable ? Theme.of(context).dividerTheme.color : const Color(0xFFDFE8EF),
                  ),
                ],
              );
            },
          ),
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
