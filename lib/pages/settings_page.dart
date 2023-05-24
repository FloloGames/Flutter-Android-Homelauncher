import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../helper/helper_functions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return HelperFunctions.PlaceholderWithText("Settings Page");
  }
}
