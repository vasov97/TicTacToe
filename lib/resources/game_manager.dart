import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../provider/room_data.dart';
import '../utils/utils.dart';

class GameManager {
  void checkWinner(BuildContext context, Socket socketClient) {
    RoomData roomDataProvider = Provider.of<RoomData>(context, listen: false);

    String winner = '';
    List<String> boardElements = roomDataProvider.displayElements;
    
    for (int i = 0; i < boardElements.length; i+=3) {
      if (boardElements[i] == boardElements[i + 1] &&
          boardElements[i] == boardElements[i + 2] &&
          boardElements[i] != '') {
            winner = boardElements[i];
          }
    }

  
    for (int i = 0; i < 3; i++) {
      if (boardElements[i] == boardElements[i + 3] &&
          boardElements[i] == boardElements[i + 6] &&
          boardElements[i] != '') {
            winner = boardElements[i];
          }
    }

    //check diagonal
  //  int boardSize = 3;//boardElements.length/3 as int;
  //  for(int i=0;i<boardSize;i+=2){
  //   if(boardElements[i]==boardElements[i+boardSize] && boardElements[i]!=''){
  //     winner = boardElements[i];
  //   }
  //   else if(roomDataProvider.filledBoxes==9){
  //     winner='';
  //     showGameDialog(context,'Draw');
  //   }
  //  }
  if (roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[8] &&
        roomDataProvider.displayElements[0] != '') {
      winner = roomDataProvider.displayElements[0];
    }
    if (roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[6] &&
        roomDataProvider.displayElements[2] != '') {
      winner = roomDataProvider.displayElements[2];
    } else if (roomDataProvider.filledBoxes == 9) {
      winner = '';
      showGameDialog(context, 'Draw');
    }


     if (winner != '') {
      if (roomDataProvider.player1.playerType == winner) {
        showGameDialog(context, '${roomDataProvider.player1.nickname} won!');
        socketClient.emit('winner', {
          'winnerSocketId': roomDataProvider.player1.socketID,
          'roomId': roomDataProvider.roomData['_id'],
        });
      } else {
        showGameDialog(context, '${roomDataProvider.player2.nickname} won!');
        socketClient.emit('winner', {
          'winnerSocketId': roomDataProvider.player2.socketID,
          'roomId': roomDataProvider.roomData['_id'],
        });
      }
    }
  }

  void clearBoard(BuildContext context) {
    RoomData roomDataProvider =
        Provider.of<RoomData>(context, listen: false);

    for (int i = 0; i < roomDataProvider.displayElements.length; i++) {
      roomDataProvider.updateDisplayElements(i, '');
    }
    roomDataProvider.setFilledBoxesTo0();
  }
}
