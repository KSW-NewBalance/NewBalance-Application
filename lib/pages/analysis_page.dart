import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:newbalance_flutter/model/FootAngle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/Event.dart';
import 'package:newbalance_flutter/util/constants.dart' as constants;

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  List<int> intensityList = [0,1,2,3,4,5];
  Map<DateTime, List<Event>> selectedEvents = Map();
  TextStyle subTitleTextStyle =
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 21);

  @override
  void initState() {
    super.initState();
    // test data to pass through to calendar
   insertDummyDataInCalendar();
  }

  void insertDummyDataInCalendar(){
    int today = DateTime.now().day;
    for (int i=1; i<today; i++){
      var date = DateTime.utc(2023, 2, i);
      var state = intensityList[Random().nextInt(5)];
      if (state == 0) continue;
      var intensity = Event(state: state);
      selectedEvents[date] = [intensity];
    }
    insertTodayIntensity();
  }

  void insertTodayIntensity() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? intensity = prefs.getInt(constants.intensityState);
    intensity ??= 0;
    debugPrint('intensity: $intensity');
    selectedEvents[DateTime.utc(2023, 2, DateTime.now().day)] = [Event(state: intensity)];
    setState(() {});
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  TableCalendar _buildCalendar() {
    double width = 1.0;
    double height = 1.0;

    return TableCalendar(
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
        ),
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        eventLoader: _getEventsfromDay,
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Color(0xff5BD4EA),
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          singleMarkerBuilder: (BuildContext context, date, _) {
            switch (selectedEvents[date]?[0].state) {
              case 1:
                width = 6.0;
                height = 6.0;
                break;
              case 2:
                width = 9.0;
                height = 9.0;
                break;
              case 3:
                width = 12.0;
                height = 12.0;
                break;
              case 4:
                width = 15.0;
                height = 15.0;
                break;
              case 5:
                width = 18.0;
                height = 18.0;
                break;
            }
            return Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffFFCD37)), //Change color
              width: width,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
            );
          },
        )
        // This trailing comma makes auto-formatting nicer for build methods.

        );
  }

  SfCartesianChart _buildGraph() {
    final List<double> angleListR = [25.0, 24.3, 24.6, 25.2, 24.0, 23.9];
    final List<double> angleListL = [22.2, 22.0, 22.9, 23.4, 23.1, 22.5];
    final List<FootAngle> footAngleListR = [];
    final List<FootAngle> footAngleListL = [];

    for (int i = 15; i < 22; i++) {
      double angleR = angleListR[Random().nextInt(angleListR.length)];
      double angleL = angleListL[Random().nextInt(angleListL.length)];
      footAngleListR.add(FootAngle(DateTime(2023, 2,i), angleR));
      footAngleListL.add(FootAngle(DateTime(2023, 2,i), angleL));
    }
    footAngleListR.add(FootAngle(DateTime(2023, 2,22), 23.6));
    footAngleListL.add(FootAngle(DateTime(2023, 2,22), 21.9));

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.days,
        interval: 1
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat("##.##°")
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom
      ),
      series: <CartesianSeries>[
        // Right foot angle
        LineSeries<FootAngle, DateTime>(
          name: constants.right,
            dataSource: footAngleListR,
            xValueMapper: (FootAngle data, _) => data.date,
            yValueMapper: (FootAngle data, _) => data.angle),
        // Left foot angle
        LineSeries<FootAngle, DateTime>(
          name: constants.left,
            dataSource: footAngleListL,
            xValueMapper: (FootAngle data, _) => data.date,
            yValueMapper: (FootAngle data, _) => data.angle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(constants.analysis),
          leading: BackButton(
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                child: Column(
                  children: [
                    Text(
                      constants.intensity,
                      style: subTitleTextStyle,
                    ),
                    _buildCalendar()
                  ],
                )),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                child: Column(
                  children: [
                    Text(
                      constants.angleChange,
                      style: subTitleTextStyle,
                    ),
                    Container(
                      child: _buildGraph(),
                    ),
                  ],
                )),
          ],
        ));
  }
}
