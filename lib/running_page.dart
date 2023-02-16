import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:newbalance_flutter/constants.dart' as constants;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class RunningPage extends StatefulWidget {
  const RunningPage({super.key});

  @override
  State<StatefulWidget> createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  late GoogleMapController _controller;

  Location _location = Location();
  LatLng _currentLatLng =
  LatLng(40.42599720832946, -86.90980084240438); // K-SW location

  final _stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(microseconds: 500), (){
        _stopWatchTimer.onStartTimer();
        _showRunningInformationBottomSheet();
      });

    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

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
                          final displayTime = StopWatchTimer.getDisplayTime(value!);
                          return _runningInformationItem(displayTime, constants.totalTime);
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
                      _numberButton(1),
                      _numberButton(2),
                      _numberButton(3),
                      _numberButton(4),
                      _numberButton(5),
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

  Stack _buildView() {
    return Stack(
      children: <Widget>[
        GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.normal,
            initialCameraPosition:
            CameraPosition(target: _currentLatLng, zoom: 17),
            myLocationEnabled: false,
            indoorViewEnabled: true,
            padding: EdgeInsets.fromLTRB(0, 0, 10, 114)
          //onCameraMove: (cameraPosition)=> debugPrint('Map Moved: ${cameraPosition}'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildView(),
    );
  }
}
