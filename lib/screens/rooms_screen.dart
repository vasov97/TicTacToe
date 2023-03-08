import 'package:flutter/material.dart';
import 'package:tic_tac_toe/responsive/responsive.dart';
import 'package:tic_tac_toe/routes/routes.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';

class Rooms extends StatelessWidget {
  const Rooms({super.key});

  void openCreateRoomScreen(BuildContext context) =>
      Navigator.pushNamed(context, createRoomRoute);

  void openJoinRoomScreen(BuildContext context) =>
      Navigator.pushNamed(context, joinRoomRoute);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Responsive(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                onPressed: () => openCreateRoomScreen(context),
                text: 'Create Room'),
            CustomButton(
                onPressed: () => openJoinRoomScreen(context),
                text: 'Join Room'),
          ],
        ),
      ),
    ));
  }
}
