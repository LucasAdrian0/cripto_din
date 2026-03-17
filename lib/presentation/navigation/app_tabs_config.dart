import 'package:cripto_din/presentation/factories/chat_page_factory.dart';
import 'package:cripto_din/presentation/pages/corretoras/corretoras_page.dart';
import 'package:cripto_din/presentation/pages/home/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'app_tab.dart';

// páginas

class AppTabsConfig {
  static List<AppTab> get tabs => [
    AppTab(
      title: "IA",
      icon: FaIcon(FontAwesomeIcons.robot),
      page: ChatPageFactory.create(),
    ),

    AppTab(
      title: "Home",
      icon: FaIcon(FontAwesomeIcons.house),
      page: Homepage(),
    ),

    AppTab(
      title: "Corretoras",
      icon: FaIcon(FontAwesomeIcons.coins),
      page: CorretorasPage(),
    ),
  ];
}
