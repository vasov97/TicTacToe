import 'package:flutter/material.dart';
import 'package:tic_tac_toe/resources/socket_manager.dart';
import 'package:tic_tac_toe/responsive/responsive.dart';
import 'package:tic_tac_toe/theme/res/colors.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';
import 'package:tic_tac_toe/widgets/custom_text_field.dart';
import 'package:tic_tac_toe/widgets/glowing_text.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _createRoomController = TextEditingController();
  final SocketManager _socketManager = SocketManager();

  @override
  void initState() {
    _socketManager.createRoomSuccessListener(context);
    super.initState();
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
                text: 'Create Room',
                fontSize: 60,
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              CustomTextField(
                controller: _createRoomController,
                hintText: 'Enter nickname',
              ),
              SizedBox(
                height: size.height * 0.045,
              ),
              CustomButton(
                  onPressed: () =>
                      _socketManager.createRoom(_createRoomController.text),
                  text: 'Create'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _createRoomController.dispose();
    super.dispose();
  }
}
