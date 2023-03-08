import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/routes/routes.dart';
import 'package:tic_tac_toe/screens/create_room_screen.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/screens/join_room_screen.dart';
import 'package:tic_tac_toe/screens/rooms_screen.dart';
import 'package:tic_tac_toe/theme/res/colors.dart';

import 'provider/room_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => RoomData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tic Tac Toe',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
        ),
        routes:{
            roomsRoute:(context)=>const Rooms(),
            joinRoomRoute:(context)=>const JoinRoomScreen(),
            createRoomRoute:(context)=>const CreateRoomScreen(),
            gameRoute:(context)=>const GameScreen(),
        },
        initialRoute: roomsRoute,
        home: const Rooms(),
      ),
    );
  }
}
