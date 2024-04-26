import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mercadovila/app/stores/theme_store.dart';
import 'package:shimmer/shimmer.dart';

class CardAccountLoading extends StatelessWidget {
  final ThemeStore themeStore = Modular.get<ThemeStore>();

  CardAccountLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).cardTheme.color!,
        highlightColor: Colors.white,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: 5,
          itemBuilder: (_, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 20,
                    decoration: BoxDecoration(
                      color: themeStore.isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: themeStore.isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
                contentPadding: const EdgeInsets.all(8),
                minLeadingWidth: 0,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: themeStore.isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                    width: 50,
                    height: 50,
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      color: themeStore.isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(2.5),
                      ),
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    width: 50,
                    height: 18,
                    decoration: BoxDecoration(
                      color: themeStore.isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(2.5),
                      ),
                    ),
                  ),
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: themeStore.isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      margin: const EdgeInsets.only(right: 10, top: 5),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      width: 80,
                      height: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 0,
                            ),
                            child: Container(
                              width: 50,
                              height: 12,
                              decoration: BoxDecoration(
                                color: themeStore.isDarkModeEnable ? const Color(0xFF435276) : const Color(0xFFEDF2F6),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(2.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: themeStore.isDarkModeEnable ? Theme.of(context).dividerTheme.color!.withOpacity(0.05) : Theme.of(context).dividerTheme.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
