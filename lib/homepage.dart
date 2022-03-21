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
    socket = SocketHelper().connectSocket(role: widget.role);
    debugPrint('${socket!.id} socket');
    super.initState();
  }

  void updateDriverLocation(){
    socket!.emit(DRIVER_LOCATION_UPDATE, {
      "longitude": -0.1869644,
      "latitude": 5.6037168,
    });
    socket!.on(DRIVER_LOCATION_UPDATE, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void driverAtPickup(){
    socket!.emit(DRIVER_AT_PICKUP, {
      "ride_id": resDet['ride_id'],
    });
    socket!.on(DRIVER_AT_PICKUP, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void driverRideReject(){
    socket!.emit(DRIVER_RIDE_REJECT, {
      "ride_id": resDet['ride_id'],
    });
    socket!.on(DRIVER_AT_PICKUP, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void acceptRide(){
    // debugPrint('accept ride resData:: '+resDet.toString());
    socket!.emit(DRIVER_RIDE_ACCEPTANCE, {
      "client_socket_id": resDet['client_socket_id'],
      "user_id": resDet['user_id'],
      "ride_id":resDet['ride_id']
    });
  }

  void startRide(){
    socket!.emit(RIDE_INITIATION, {
      "ride_id": resDet['ride_id']
    });
    socket!.on(RIDE_INITIATION, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void endRide(){
    socket!.emit(RIDE_COMPLETION, {
      "ride_id": resDet['ride_id']
    });
    socket!.on(RIDE_COMPLETION, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void cancelRide(){
    socket!.emit(RIDE_CANCELLATION, {
      "ride_id": resDet['ride_id']
    });
    socket!.on(RIDE_CANCELLATION, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void driverActivenessUpdate (){
    //if you want to update the is online attribute
    socket!.emit(DRIVER_ACTIVENESS_UPDATE, {
      "is_online": true
    });

    //if you want to update is_available attribute.
    socket!.emit(DRIVER_ACTIVENESS_UPDATE, {
      "is_available": true
    });
    socket!.on(DRIVER_ACTIVENESS_UPDATE, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _promoCodeController = TextEditingController();
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