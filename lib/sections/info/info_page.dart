import 'package:flutter/widgets.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/menu_aside.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class InfoPage extends StatefulWidget {
  static const String infoPageRoute = StringConst.INFO_PAGE;

  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();

    return SideMenu(
      key: sideMenuKey,
      background: AppColors.black,
      type: SideMenuType.shrinkNSlide,
      child: Container(color: AppColors.aeriumV2NavTitle),
      menu: MenuAside(
        context,
        closeMenu: () => sideMenuKey.currentState?.closeSideMenu(),
      ),
    );
  }
}
