import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
          padding: EdgeInsets.fromLTRB(0, 0, 12, 114)
          //onCameraMove: (cameraPosition)=> debugPrint('Map Moved: ${cameraPosition}'),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 42.0),
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Start'),
            style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
                minimumSize: Size.fromHeight(64), shadowColor: Colors.grey),
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
