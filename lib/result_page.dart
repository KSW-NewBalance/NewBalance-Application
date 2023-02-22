import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:newbalance_flutter/constants.dart' as constants;
import 'package:newbalance_flutter/main_page.dart';
import 'package:newbalance_flutter/services/thingsboard_service.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key,
      required this.totalTime,
      required this.distance,
      required this.state});

  final String totalTime;
  final String distance;
  final int state;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
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
    date = DateFormat('MM/dd/yyyy   kk:mm').format(DateTime.now());
  }

  void getFootData() {
    var rightFootData = ThingsBoardService.getSharedAttributes(
        ThingsBoardService.rightFootDevice);
    rightFootData.then((data) {
      rightFootAngle = data[constants.avgFootAngle];
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
      leftFootAngle = data[constants.avgFootAngle];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Results"),
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage(state: widget.state)));
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
                        Text(widget.totalTime.toString(),
                            style: const TextStyle(fontSize: 20)),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                          alignment: Alignment.center,
                          child: const Text("Total time",
                              style: TextStyle(color: Colors.blue)),
                        )
                      ]),
                      Column(children: <Widget>[
                        Text(widget.distance,
                            style: const TextStyle(fontSize: 20)),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                          alignment: Alignment.center,
                          child: const Text("Distance",
                              style: TextStyle(color: Colors.blue)),
                        )
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
                      Text('${double.parse(rightFootAngle.toStringAsFixed(2))}°',
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
