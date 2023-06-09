
// Socket.io is a popular library used to implement web sockets.

How does it work?

Our flutter app will be considered as a Client, while your backend is considered as Server and we will be establishing a bi-directional and real-time data transmission between them using Socket IO. Below are the flow steps you need to follow for successful data transmission.

1. First, we have to build a connection with the server.
2. Your app will be listening to events, so if a new event arrives, your UI will reflect it immediately (Like listening to new messages in Chat).
3. You can emit events, maybe when you want to broadcast some data to your backend (Like emitting a new message to Chat).
4. Don’t forget to close the connection between client and server.


dependencies:
socket_io_client: ^2.0.0

import 'package:socket_io_client/socket_io_client.dart' as IO;


  // This socketprovider class is used to handle all socket events like socket connect, disconnect, on and emit events.
  // The emit event is used when the user performs any functionality, and the socket.on event is used to send real-time downloads to another user's device.
  // We should use one provider so that we can easily manage all tasks from one page.

class SocketProvider extends ChangeNotifier {

    //set all socket attributes and also set autoConnect false.
    IO.Socket socket = IO.io(['url'], <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'userName': ['userName'], 'registrationToken': ['token']}
    });
  
  

    //socket connect
    void connect() {
        socket.connect(); //if socket connect successfully then it returns socket.connected true and then go onConnect method.
    
        //return callback when socket connect successfully
        socket.onConnect((_) {
            print('connection established');//socket connected successfully
            socket.emit('setup', (id));//connect and set up in backend side
            socket.on('connected', (id) => print('=== connected ==='));//when restart backend server it's connect automatically in server.
        });
    
        socket.onConnectError((err) => print(err)); // return error
        socket.onError((err) => print(err)); // return error
         
       // To add a listener, you can use socket.on(), and it will start listening to new events and will be triggered on all emits that happen on the socket server.

        socket.on('unBlock', (data) => print(data));//when other user unblock you your list is update in real time without refresh page or app
        socket.on('block', (receiveBlockChatRoom) => print(receiveBlockChatRoom));//when other user block you your list is update in real time without refresh page or app
        socket.on('message received', (newMessageRecieved) => print(newMessageRecieved));//message received when other users message you and chat list update automatically
    }
    
    //message send
    void sendMessage() {
        socket.emit('new message', msg);//This event is emitted in the backend when a user message to another user, and the backend returns the socket.on event in the other user's device.
        notifyListeners();
    }
    
    //block user
    void onBlockUser() {
        socket.emit('block User', chatRoom);//This event is emitted in the backend when a user block another user, and the backend returns the socket.on event in the other user's device.
        notifyListeners();
    }
    
    //unblockuser
    void onUnBlockUser() {
        socket.emit('unBlock User', blockUSerId); // This event is emitted in the backend when a user unblock another user, and the backend returns the socket.on event in the other user's device.
        notifyListeners();
    }
    
    //socket disconnect
    void disConnect() {
        socket.emit('disconnection', userID); // The socket is disconnect in the backend.
        socket.disconnect(); //The socket is disconnect when the application is closed.
        socket.dispose();
        notifyListeners();
    }
}