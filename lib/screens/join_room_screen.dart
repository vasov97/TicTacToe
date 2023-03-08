import 'package:flutter/material.dart';
import 'package:tic_tac_toe/resources/socket_manager.dart';

import '../responsive/responsive.dart';
import '../theme/res/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glowing_text.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomIdController = TextEditingController();
  final SocketManager _socketManager = SocketManager();

  @override
  void initState() {
    super.initState();
    _socketManager.joinRoomSuccessListener(context);
    _socketManager.errorOccuredListener(context);
    _socketManager.updatePlayersStateListener(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Responsive(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const GlowingText(
                shadows: [
                  Shadow(
                    blurRadius: 40,
                    color: primaryColor,
                  ),
                ],
                text: 'Join Room',
                fontSize: 60,
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              CustomTextField(
                controller: _nameController,
                hintText: 'Enter nickname',
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: _roomIdController,
                hintText: 'Enter room ID',
              ),
              SizedBox(
                height: size.height * 0.045,
              ),
              CustomButton(
                onPressed: () => _socketManager.joinRoom(
                  _nameController.text,
                  _roomIdController.text,
                ),
                text: 'Join',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomIdController.dispose();
    super.dispose();
  }
}
