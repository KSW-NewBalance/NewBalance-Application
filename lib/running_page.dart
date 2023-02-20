import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:newbalance_flutter/constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class RunningPage extends StatefulWidget {
  const RunningPage({super.key});

  @override
  State<StatefulWidget> createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final double zoomSize = 18.0;
  final _stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  Location _location = Location(); // K-SW location

  List<LatLng> _polyline = [];
  LocationData? currentLocation;
  LatLng source = LatLng(40.42599720832946, -86.90980084240438);

  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    getSourceLatLngInSF();
    setCustomMarkerIcon();
    getCurrentLocation();
    super.initState();
  }

  void getSourceLatLngInSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble(constants.latitude);
    double? longitude = prefs.getDouble(constants.longitude);
    if (latitude != null && longitude != null) {
      source = LatLng(latitude, longitude);
      debugPrint('source = ${source.latitude}, ${source.longitude}');
      setState(() {
        _polyline.add(source);
      });
    }
  }

  void addPolyPoints(LocationData locationData) {
    setState(() {
      LatLng latLng = LatLng(locationData.latitude!, locationData.longitude!);
      _polyline.add(latLng);
    });
  }

  void getCurrentLocation() async {
    await _location.getLocation().then((location) {
      currentLocation = location;
    });
    setState(() {});
    debugPrint('currentLocation: ${currentLocation}');

    GoogleMapController googleMapController = await _controller.future;

    _location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;

        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(newLoc.latitude!, newLoc.longitude!),
          zoom: zoomSize,
        )));
        addPolyPoints(newLoc);
      });
    });
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(44, 35)),
            "assets/images/footprint.png")
        .then((icon) {
      currentIcon = icon;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(microseconds: 500), () {
        //_stopWatchTimer.onStartTimer();
        //_showRunningInformationBottomSheet();
      });
    });
  }

  Column _runningInformationItem(String data, String type) {
    const h3TextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 24);
    return Column(
      children: [
        Text(
          data,
          style: h3TextStyle,
        ),
        Text(
          type,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Text _bottomSheetHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  Container _showRunningInformationBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.grey[200],
        builder: (BuildContext context) {
          return Container(
            height: 340,
            padding: EdgeInsets.fromLTRB(30, 35, 30, 0),
            child: Column(
              children: <Widget>[
                _bottomSheetHeaderText(constants.runningInformation),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.fromLTRB(0, 18, 0, 21),
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _runningInformationItem('0.00', constants.distance),
                      StreamBuilder<int>(
                        stream: _stopWatchTimer.rawTime,
                        initialData: 0,
                        builder: (context, snap) {
                          final value = snap.data;
                          final displayTime =
                              StopWatchTimer.getDisplayTime(value!)
                                  .substring(3, 8);
                          return _runningInformationItem(
                              displayTime, constants.totalTime);
                        },
                      ),
                      _runningInformationItem('_\'__\"', constants.averagePage),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _stopWatchTimer.onResetTimer();
                    _showRunningQuestionBottomSheet();
                  },
                  child: Icon(
                    Icons.stop,
                    size: 55,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(5),
                  ),
                )
              ],
            ),
          );
        });
    return Container();
  }

  ElevatedButton _numberButton(int num) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: Colors.blue,
          minimumSize: Size(44, 45),
          textStyle: const TextStyle(
              fontSize: 21, color: Colors.white, fontWeight: FontWeight.w500)),
      child: Text('$num'),
    );
  }

  Column _signNumber(String path, String text) {
    return Column(children: <Widget>[
      Image.asset(path, width: 24, height: 18, color: Colors.grey[900]),
      Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    ]);
  }

  Container _showRunningQuestionBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.grey[200],
        builder: (BuildContext context) {
          return Container(
              height: 230,
              padding: EdgeInsets.fromLTRB(42, 35, 42, 20),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  _bottomSheetHeaderText(constants.afterRunningQuestion),
                  SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      for (int i = 1; i <= 5; i++) _numberButton(i),
                    ],
                  ),
                  SizedBox(height: 21),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(children: <Widget>[
                        _signNumber(
                            'assets/images/left_arrow.png', constants.easy)
                      ]),
                      Column(children: <Widget>[
                        _signNumber(
                            'assets/images/right_arrow.png', constants.hard)
                      ]),
                    ],
                  )
                ],
              ));
        });

    return Container();
  }

  GoogleMap _buildView() {
    return GoogleMap(
      onMapCreated: (mapController) {
        _controller.complete(mapController);
      },
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target:
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: zoomSize),
      myLocationEnabled: false,
      indoorViewEnabled: true,
      padding: EdgeInsets.fromLTRB(0, 0, 10, 114),
      polylines: {
        Polyline(
            polylineId: PolylineId("route"),
            points: _polyline,
            color: constants.secondaryColor,
            width: 6
            //patterns: [PatternItem.dash(10), PatternItem.gap(10)],
            )
      },
      markers: {
        Marker(
            markerId: MarkerId("currentLocation"),
            position:
                LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            icon: currentIcon),
        //Marker(markerId: MarkerId("source"), position: source),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? Container(
              alignment: Alignment.center,
              color: Colors.blue,
              child: const Text(
                '0',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 140,
                    color: Colors.white),
              ),
            )
          : _buildView(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }
}