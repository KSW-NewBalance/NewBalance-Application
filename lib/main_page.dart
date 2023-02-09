import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const LatLng _latLng =
      const LatLng(37.42796133580664, -122.085749655962);
  LatLng _lastPosition = _latLng;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
  }

  static const CameraPosition _kGooglePlex =
      CameraPosition(target: _latLng, zoom: 11.0);

  Stack _buildView() {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onCameraMove: _onCameraMove,
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
