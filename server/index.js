const express = require('express');
const http=require('http');
const mongoose = require('mongoose');

const app = express();
const port = process.env.PORT || 3000;

var server = http.createServer(app);
const Room = require('./models/room.js');
var io = require('socket.io')(server);

let random = Math.floor(Math.random*2);
app.use(express.json);

const mongoDB = "mongodb+srv://vasovmail:test123@cluster0.oamblmw.mongodb.net/?retryWrites=true&w=majority";

io.on("connection",(socket)=>{
  console.log('Socket connected');
  socket.on('createRoom', async ({nickname})=>{
    console.log(nickname);
    try{
     
      
      let room = new Room();
      let player = {
           socketID:socket.id,
           nickname,
           playerType:random==0?'X':'O',
      };
      room.players.push(player);
      room.turn=player;
      room = await room.save();
  
      const roomId= room._id.toString();
      socket.join(roomId);

      io.to(roomId).emit('createRoomSuccess',room);
      console.log(room);
    }catch(e){
      console.log(e);
    }
    
    });

    socket.on('joinRoom',async ({nickname,roomId})=>{
        try{
           if(!roomId.match(/^[0-9a-fA-F]{24}$/)){
             socket.emit('errorOccured','Please enter a valid room ID');
             return;
             //not io bc we want to emit to our client not to everyone in the room
           }
           let room = await Room.findById(roomId);
           if(room.isJoin){
             let player ={
              nickname,
              socketID:socket.id,
              playerType:random==0?'O':'X',
              
             }
             socket.join(roomId);
             room.players.push(player);
             room.isJoin=false;//now third user wont be able to join in
             room= await room.save();
             io.to(roomId).emit('joinRoomSuccess',room);
             io.to(roomId).emit('updatePlayers',room.players);
             io.to(roomId).emit('updateRoom',room);
           }
           else{
            socket.emit('errorOccured','The game is in progress, try again later');
           }
        }catch(e){
          console.log(e);
        }
    });

  socket.on('tap',async({index,roomId})=>{
    try{
       let room = await Room.findById(roomId);
       let choice = room.turn.playerType;
       if(room.turnIndex==0){
        room.turn=room.players[1];
        room.turnIndex=1;
       }
       else{
        room.turn=room.players[0];
        room.turnIndex=0;
       }
       room = await room.save();
       io.to(roomId).emit('tapped',{
        index,
        choice,
        room,
       })
    }catch(e){
      console.log(e);
    }
  });

  socket.on('winner',async({winnerSocketId, roomId})=>{
     try{
      let room = await Room.findById(roomId);
      let player = room.players.find((player)=>player.socketID==winnerSocketId);
      player.points=player.points+1;
      console.log(player.points);
      room=await room.save();

      if(player.points>=room.maxRounds){
        io.to(roomId).emit('endGame',player);
        
      }
      else{
        player.points/=2;
        io.to(roomId).emit('pointIncrease',player);
      }
     }catch(e){
      console.log(e);
     }
  });
});

mongoose.set("strictQuery",false);
mongoose.connect(mongoDB).then(()=>{
  console.log('Connection successful');
}).catch((e)=>{
  console.log(e);
});

server.listen(port,'0.0.0.0',()=>{
  console.log(`Server started and running on port ${port}`);
});
