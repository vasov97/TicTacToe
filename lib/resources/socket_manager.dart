import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tic_tac_toe/provider/room_data.dart';
import 'package:tic_tac_toe/resources/game_manager.dart';
import 'package:tic_tac_toe/resources/socket_client.dart';
import 'package:tic_tac_toe/routes/routes.dart';

import '../utils/utils.dart';

class SocketManager{
  final _socketClient = SocketClient.instance.socket!;
  Socket get socketClient => _socketClient;

  void createRoom(String nickname){
    if(nickname.isNotEmpty){
      //send data to server
      _socketClient.emit('createRoom',{
        'nickname':nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId){
    if(nickname.isNotEmpty && roomId.isNotEmpty){
      _socketClient.emit('joinRoom',{
        'nickname':nickname,
        'roomId':roomId,
      });
    }
  }

   void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketClient.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  void createRoomSuccessListener(BuildContext context){
    _socketClient.on('createRoomSuccess',(room){
      Provider.of<RoomData>(context,listen:false).updateRoomData(room);
      Navigator.pushNamed(context,gameRoute);
    });
  }

  void joinRoomSuccessListener(BuildContext context) {
    _socketClient.on('joinRoomSuccess', (room) {
      Provider.of<RoomData>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, gameRoute);
    });
  }

  void errorOccuredListener(BuildContext context) {
    _socketClient.on('errorOccurred', (data) {
      showSnackBar(context, data);
    });
  }

   void updatePlayersStateListener(BuildContext context) {
    _socketClient.on('updatePlayers', (playerData) {
      Provider.of<RoomData>(context, listen: false).updatePlayer1(
        playerData[0],
      );
      Provider.of<RoomData>(context, listen: false).updatePlayer2(
        playerData[1],
      );
    });
  }

  void winsIncreaseListener(BuildContext context){
    _socketClient.on('winsIncrease', (playerData) {
      Provider.of<RoomData>(context,listen:false).updatePlayer1(
        playerData[0],
      );
      Provider.of<RoomData>(context, listen: false).updatePlayer2(
        playerData[1],
      );
    });
  }

   void updateRoomListener(BuildContext context) {
    _socketClient.on('updateRoom', (data) {
      Provider.of<RoomData>(context, listen: false)
          .updateRoomData(data);
    });
  }

  void tappedListener(BuildContext context) {
    _socketClient.on('tapped', (data) {
      RoomData roomDataProvider =
          Provider.of<RoomData>(context, listen: false);
      roomDataProvider.updateDisplayElements(
        data['index'],
        data['choice'],
      );
      roomDataProvider.updateRoomData(data['room']);
      // check winnner
      GameManager().checkWinner(context, _socketClient);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    _socketClient.on('pointIncrease', (playerData) {
      var roomDataProvider =
          Provider.of<RoomData>(context, listen: false);
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListener(BuildContext context) {
    _socketClient.on('endGame', (playerData) {
      showGameDialog(context, '${playerData['nickname']} won the game!');
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }

}