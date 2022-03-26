import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:ride_app/other_page.dart';
import 'package:ride_app_driver/socket.dart';
import 'package:ride_app_driver/utils.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomePage extends StatefulWidget {
  final int id;
  final String role;
  const HomePage({ Key? key, required this.id, required this.role }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Socket? socket;
  Map resDet = SocketHelper().getData;
  String status = 'pending';
  String response = "connecting to socket...";
  
  @override
  void initState() {
    socket = SocketHelper().connectSocket();
    debugPrint('${socket!.id} socket');
    super.initState();
  }

  // call when driver wants to update location
  void updateDriverLocation(){
    socket!.emit(driverLocationUpdate, {
      "longitude": -0.1869644,
      "latitude": 5.6037168,
    });
  }

  // call when driver gets to pickup location
  void emitDriverAtPickup(){
    socket!.emit(driverAtPickup, {
      "ride_id": resDet['ride_id'],
    });
  }

  // call when driver gets to destination
  void emitDriverAtDestination(){
    socket!.emit(driverAtDestination, {
      "ride_id": resDet['ride_id'],
    });
  }

  // call when driver wants to rejects a pending ride
  void rideReject(){
    socket!.emit(driverRideReject, {
      "ride_id": resDet['ride_id'],
    });
  }

  // call when driver wants to accepts a pending ride
  void acceptRide(){
    socket!.emit(driverRideAcceptance, {
      "client_socket_id": resDet['client_socket_id'],
      "ride_id":resDet['ride_id']
    });
  }

  // call when driver wants to start a ride
  void startRide(){
    socket!.emit(rideInitiation, {
      "ride_id": resDet['ride_id']
    });
  }

  // call when driver wants to end a ride
  void endRide(){
    socket!.emit(rideCompletion, {
      "ride_id": resDet['ride_id']
    });
  }

  // call when driver wants to cancel a ride
  void cancelRide(){
    socket!.emit(rideCancellation, {
      "ride_id": resDet['ride_id']
    });
  }

  // call when driver wants to update activeness (whether is_online or is_available)
  void activenessUpdate (){
    //if you want to update the is online attribute
    socket!.emit(driverActivenessUpdate, {
      "is_online": true
    });

    //if you want to update is_available attribute.
    socket!.emit(driverActivenessUpdate, {
      "is_available": true
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(socket!.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.role} dashboard -- id:${widget.id}'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(SocketHelper().response, style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  color: status == 'success' ? Colors.green 
                  : status == 'failed' ? Colors.red :
                  Colors.amber 
                )
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('end ride', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  endRide();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('cancel ride', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  cancelRide();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('update location', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  updateDriverLocation();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('start ride', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  startRide();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('accept ride', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  acceptRide();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}