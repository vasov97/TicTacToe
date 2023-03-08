import 'package:flutter/material.dart';

import '../resources/game_manager.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

void showGameDialog(BuildContext context, String text) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                GameManager().clearBoard(context);
                //Navigator.pop(context);
                
              },
              child: const Text(
                'Play Again',
              ),
            ),
          ],
        );
      });
}