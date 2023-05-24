import 'dart:async';

import 'package:flutter/material.dart';

class HelperFunctions {
  static String get packageName => "com.floloGames.flos_home_launcher";
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Future<bool> showDialogQuestion(
    BuildContext context,
    String question,
  ) async {
    bool response = false;
    await showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (builderContext) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 90, 90, 90),
        shadowColor: Colors.transparent,
        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Nein',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              response = true;
              Navigator.of(context).pop();
            },
            child: const Text(
              'Ja',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    return response;
  }

  static Future<String?> showDialogTextInputQuestion(
      BuildContext context, String question) async {
    TextEditingController textEditingController = TextEditingController();
    String? returnString;
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 90, 90, 90),
        shadowColor: Colors.transparent,
        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        content: TextField(
          controller: textEditingController,
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              returnString = textEditingController.text;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );

    return returnString;
  }

  static Future showDialogInfo(BuildContext context, String info) async {
    await showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (builderContext) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 90, 90, 90),
        shadowColor: Colors.transparent,
        title: Text(
          info,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Widget PlaceholderWithText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
      );
}
