import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/resources/socket_manager.dart';
import 'package:tic_tac_toe/widgets/game_board.dart';
import 'package:tic_tac_toe/widgets/scoreboard.dart';
import 'package:tic_tac_toe/widgets/waiting_lobby.dart';

import '../provider/room_data.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketManager _socketManager = SocketManager();

  @override
  void initState() {
    super.initState();
    _socketManager.updateRoomListener(context);
    _socketManager.updatePlayersStateListener(context);
    _socketManager.pointIncreaseListener(context);
    _socketManager.endGameListener(context);
  }

  @override
  Widget build(BuildContext context) {
    final roomDataProvider = Provider.of<RoomData>(context);
    return Scaffold(
      body: roomDataProvider.roomData['isJoin']
          ? const WaitingLobby()
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Scoreboard(),
                  const GameBoard(),
                  Text(
                      '${roomDataProvider.roomData['turn']['nickname']}\'s turn',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ),
    );
  }
}
