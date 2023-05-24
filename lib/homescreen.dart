import 'package:flos_launcher/helper/helper_functions.dart';
import 'package:flos_launcher/pages/all_apps_page.dart';
import 'package:flos_launcher/pages/home_page.dart';
import 'package:flos_launcher/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(
    initialPage: 1,
    keepPage: true, //not sure
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Remove top bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: HelperFunctions.getScreenWidth(context),
        height: HelperFunctions.getScreenHeight(context),
        child: PageView(
          controller: _pageController,
          children: const [
            SettingsPage(),
            HomePage(),
            AllAppsPage(),
          ],
        ),
      ),
    );
  }
}
