import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:newbalance_flutter/constants.dart' as constants;
import 'package:newbalance_flutter/main_page.dart';
import 'package:newbalance_flutter/services/thingsboard_service.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key,
      required this.totalTime,
      required this.distance,
        required this.polyline});

  final int totalTime;
  final double distance;
  final List<LatLng> polyline;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final Completer<GoogleMapController> _controller = Completer();

  double rightFootAngle = 0.0;
  double leftFootAngle = 0.0;

  static List<String> colorList = ['B', 'G', 'Y', 'R'];

  String foreFootColorL = colorList[0];
  String medialFootColorL = colorList[0];
  String lateralFootColorL = colorList[0];
  String rearFootColorL = colorList[0];
  String foreFootColorR = colorList[0];
  String medialFootColorR = colorList[0];
  String lateralFootColorR = colorList[0];
  String rearFootColorR = colorList[0];

  late String date;

  @override
  void initState() {
    super.initState();
    getFootData();
    // test running stats
    date = DateFormat('MM/dd/yyyy   kk:mm a').format(DateTime.now());
  }

  void getFootData() {
    var rightFootData = ThingsBoardService.getSharedAttributes(
        ThingsBoardService.rightFootDevice);
    rightFootData.then((data) {
      rightFootAngle = data[constants.avgFootAngle].toDouble();
      data.remove(constants.avgFootAngle);

      var sortedKeys = data.keys.toList(growable: false)
        ..sort((k1, k2) => data[k1].compareTo(data[k2]));
      debugPrint('right: $sortedKeys');

      for (int i = 0; i < 4; i++) {
        switch (sortedKeys[i]) {
          case 'total_fsr_1st':
            foreFootColorR = colorList[i];
            break;
          case 'total_fsr_2nd':
            medialFootColorR = colorList[i];
            break;
          case 'total_fsr_3rd':
            lateralFootColorR = colorList[i];
            break;
          case 'total_fsr_4th':
            rearFootColorR = colorList[i];
            break;
        }
      }
      setState(() {});
      debugPrint(
          '$foreFootColorR, $medialFootColorR, $lateralFootColorR, $rearFootColorR');
    });

    var leftFootData = ThingsBoardService.getSharedAttributes(
        ThingsBoardService.leftFootDevice);
    leftFootData.then((data) {
      leftFootAngle = data[constants.avgFootAngle].toDouble();

      data.remove(constants.avgFootAngle);

      var sortedKeys = data.keys.toList(growable: false)
        ..sort((k1, k2) => data[k1].compareTo(data[k2]));
      debugPrint('left: $sortedKeys');

      for (int i = 0; i < 4; i++) {
        switch (sortedKeys[i]) {
          case 'total_fsr_1st':
            foreFootColorL = colorList[i];
            break;
          case 'total_fsr_2nd':
            medialFootColorL = colorList[i];
            break;
          case 'total_fsr_3rd':
            lateralFootColorL = colorList[i];
            break;
          case 'total_fsr_4th':
            rearFootColorL = colorList[i];
            break;
        }
      }
      setState(() {});
      debugPrint(
          '$foreFootColorL, $medialFootColorL, $lateralFootColorL, $rearFootColorL');
    });
  }

  GoogleMap _buildRoute() {
    var centerLat = (widget.polyline.last.latitude + widget.polyline.first.latitude)/2;
    var centerLng = (widget.polyline.last.longitude + widget.polyline.first.longitude)/2;

    return GoogleMap(
      onMapCreated: (mapController) {
        _controller.complete(mapController);
      },
        initialCameraPosition: CameraPosition(
      target: LatLng(centerLat, centerLng), zoom: 15),
      mapType: MapType.normal,
      polylines: {
        Polyline(
            polylineId: PolylineId("route"),
            points: widget.polyline,
            color: constants.secondaryColor,
            width: 6)
      },
      myLocationButtonEnabled: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var pace =
        ((widget.totalTime / 1000 / 60) / widget.distance).toStringAsFixed(2);
    var paceList = pace.split('.');
    debugPrint('${pace.split('.')}');

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(constants.results),
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage()));
            },
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
            /*
          Section 1: Run path and stats
           */
            Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  date,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                )),
            Container(
              height: 200,
              width: 400,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(children: <Widget>[
                Expanded(
                  flex: 2,
                  child: _buildRoute(),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(children: <Widget>[
                            Text(
                                '${StopWatchTimer.getDisplayTime(widget.totalTime).substring(3, 8)} ',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                              alignment: Alignment.center,
                              child: const Text(constants.totalTime,
                                  style: TextStyle(color: Colors.blue)),
                            )
                          ]),
                          Column(children: <Widget>[
                            Text('${widget.distance.toStringAsFixed(2)} km',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                              alignment: Alignment.center,
                              child: const Text(constants.distance,
                                  style: TextStyle(color: Colors.blue)),
                            )
                          ]),
                          Column(
                            children: <Widget>[
                              Text('${paceList[0]}\' ${paceList[1]}\"',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                constants.averagePage,
                                style: TextStyle(color: Colors.blue),
                              )
                            ],
                          )
                        ]))
              ]),
            ),

            /*
          Section 2: Foot angle
           */
            Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  constants.angle,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                )),
            Container(
              height: 200,
              width: 400,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('${double.parse(leftFootAngle.toStringAsFixed(2))}°',
                          style: const TextStyle(color: Colors.blue)),
                      Stack(children: <Widget>[
                        Image.asset(
                          'assets/images/left_standard.png',
                          width: 150,
                          fit: BoxFit.fitWidth,
                        ),
                        Transform.rotate(
                            angle: -leftFootAngle * math.pi / 180,
                            // must convert to radians for image
                            child: Image.asset(
                              'assets/images/left_foot.png',
                              width: 150,
                              fit: BoxFit.fitWidth,
                            ))
                      ])
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                          '${double.parse(rightFootAngle.toStringAsFixed(2))}°',
                          style: const TextStyle(color: Colors.blue)),
                      Stack(children: <Widget>[
                        Image.asset(
                          'assets/images/right_standard.png',
                          width: 150,
                          fit: BoxFit.fitWidth,
                        ),
                        Transform.rotate(
                            angle: rightFootAngle * math.pi / 180,
                            child: Image.asset(
                              'assets/images/right_foot.png',
                              width: 150,
                              fit: BoxFit.fitWidth,
                            )),
                      ])
                    ],
                  ),
                ], //   <--- image
              ),
            ),

            /*
          Section 3: first point of contact
           */
            Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  constants.landingLocation,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                )),
            Container(
              height: 200,
              width: 400,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
              decoration: const BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Image.asset(
                          'assets/images/left_foot.png',
                          width: 150,
                          fit: BoxFit.fitWidth,
                        ),
                        Positioned(
                            left: 62,
                            top: 12,
                            child: Image.asset(
                              'assets/images/fore_foot$foreFootColorL.png',
                              width: 35,
                              fit: BoxFit.fitWidth,
                            )),
                        Positioned(
                            left: 64,
                            top: 112,
                            child: Image.asset(
                              'assets/images/rear_foot$rearFootColorL.png',
                              width: 25,
                              fit: BoxFit.fitWidth,
                            )),
                        Positioned(
                            left: 75,
                            top: 54,
                            child: Image.asset(
                              'assets/images/medial_foot$medialFootColorL.png',
                              width: 20,
                              fit: BoxFit.fitWidth,
                            )),
                        Positioned(
                            left: 58,
                            top: 54,
                            child: Image.asset(
                              'assets/images/lateral_foot$lateralFootColorL.png',
                              width: 12,
                              fit: BoxFit.fitWidth,
                            )),
                      ]),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Image.asset(
                          'assets/images/right_foot.png',
                          width: 150,
                          fit: BoxFit.fitWidth,
                        ),
                        Positioned(
                            left: 54,
                            top: 12,
                            child: Image.asset(
                              'assets/images/fore_foot$foreFootColorR.png',
                              width: 35,
                              fit: BoxFit.fitWidth,
                            )),
                        Positioned(
                            left: 62,
                            top: 112,
                            child: Image.asset(
                              'assets/images/rear_foot$rearFootColorR.png',
                              width: 25,
                              fit: BoxFit.fitWidth,
                            )),
                        Positioned(
                          left: 56,
                          top: 54,
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Image.asset(
                                'assets/images/medial_foot$medialFootColorR.png',
                                width: 20,
                                fit: BoxFit.fitWidth,
                              )),
                        ),
                        Positioned(
                            left: 80,
                            top: 54,
                            child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Image.asset(
                                  'assets/images/lateral_foot$lateralFootColorR.png',
                                  width: 12,
                                  fit: BoxFit.fitWidth,
                                ))),
                      ])
                    ],
                  ),
                ], //   <--- image
              ),
            ),
          ])),
        ]));
  }
}
