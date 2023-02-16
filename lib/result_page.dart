import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class ResultPage extends StatefulWidget {
  ResultPage({super.key, required this.title});

  final String title;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = <Guid, List<int>>{};

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late double rightFootAngle;
  late double leftFootAngle;

  late String foreFootColorL;
  late String medialFootColorL;
  late String lateralFootColorL;
  late String rearFootColorL;
  late String foreFootColorR;
  late String medialFootColorR;
  late String lateralFootColorR;
  late String rearFootColorR;

  late String date;
  late String totalTime;
  late String distance;
  late String averagePace;

  @override
  void initState() {
    super.initState();
    // test angles in degrees, need to load this in from api
    leftFootAngle = 5;
    rightFootAngle = 15;

    // test colors
    foreFootColorL = 'Y';
    rearFootColorL = 'R';
    medialFootColorL = 'B';
    lateralFootColorL = 'G';

    foreFootColorR = 'R';
    rearFootColorR = 'Y';
    medialFootColorR = 'G';
    lateralFootColorR = 'B';

    // test running stats
    totalTime = "1:56";
    distance = "0.45km";
    averagePace = "02.13";
    date = DateFormat('MM/dd/yyyy   kk:mm').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
            /*
          Section 1: Run path and stats
           */
            Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  date,
                  style: const TextStyle(fontSize: 20),
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
                    child: Column(children: const <Widget>[
                      // TODO map picture
                    ])),
                Expanded(
                    flex: 1,
                    child: Column(children: <Widget>[
                      Column(children: <Widget>[
                        Text(totalTime, style: const TextStyle(fontSize: 20)),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                          alignment: Alignment.center,
                          child: const Text("Total time",
                              style: TextStyle(color: Colors.blue)),
                        )
                      ]),
                      Column(children: <Widget>[
                        Text(distance, style: const TextStyle(fontSize: 20)),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                          alignment: Alignment.center,
                          child: const Text("Distance",
                              style: TextStyle(color: Colors.blue)),
                        )
                      ]),
                      Column(children: <Widget>[
                        Text(averagePace, style: const TextStyle(fontSize: 20)),
                        const Text("Average Pace",
                            style: TextStyle(color: Colors.blue)),
                        const Text("(min/km)",
                            style: TextStyle(color: Colors.blue, fontSize: 10)),
                      ]),
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
                  "Angle",
                  style: TextStyle(fontSize: 20),
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
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("$leftFootAngle°",
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
                      Text("$rightFootAngle°",
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
                  "Landing Location",
                  style: TextStyle(fontSize: 20),
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