import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:newbalance_flutter/constants.dart' as constants;

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late GoogleMapController _controller;

  Location _location = Location();
  LatLng _currentLatLng =
      LatLng(40.42599720832946, -86.90980084240438); // K-SW location

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    setState(() {
      _location.onLocationChanged.listen((l) {
        _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(l.latitude!, l.longitude!), zoom: 17)));
        _currentLatLng = LatLng(l.latitude!, l.longitude!);
      });
    });
  }

  Container _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 332,
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: 35, horizontal: 30),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  constants.runningInformation,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.fromLTRB(0, 17, 0, 21),
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: const [
                          Text('0.00', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),),
                          Text(constants.distance, style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('00:00', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),),
                          Text(constants.totalTime, style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('_\'__\"', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),),
                          Text(constants.averagePage, style: TextStyle(fontSize: 12),),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
    return Container();
  }

  Stack _buildView() {
    return Stack(
      children: <Widget>[
        GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.normal,
            initialCameraPosition:
                CameraPosition(target: _currentLatLng, zoom: 17),
            myLocationEnabled: true,
            indoorViewEnabled: true,
            padding: EdgeInsets.fromLTRB(0, 0, 10, 114)
            //onCameraMove: (cameraPosition)=> debugPrint('Map Moved: ${cameraPosition}'),
            ),
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 42.0),
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: _showBottomSheet,
            child: Text(constants.start),
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              minimumSize: Size.fromHeight(64),
              shadowColor: Colors.grey,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          margin: EdgeInsets.fromLTRB(0.0, 24.0, 10.0, 0.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 11.0),
              shadowColor: Colors.grey,
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildView(),
    );
  }
}
