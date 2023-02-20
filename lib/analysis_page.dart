import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Event.dart';

class AnalysisPage extends StatefulWidget {
  AnalysisPage({super.key, required this.title});

final String title;

@override
State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late Map<DateTime, List<Event>> selectedEvents;
  @override
  void initState() {
    super.initState();
    // test data to pass through to calendar
    // TODO: need to find average of states and then pass that array to the eventLoader
    selectedEvents = {DateTime.utc(2023,2,7): [Event(state: 3)] , DateTime.utc(2023,2,4): [Event(state: 1)],  DateTime.utc(2023,2,19): [Event(state: 5)]};
  }
  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    double width = 1.0;
    double height = 1.0;


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible : false,
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
              singleMarkerBuilder: (BuildContext context, date,_) {
                switch(selectedEvents[date]?[0].state) {
                  case 1:
                    width = 7.0;
                    height = 7.0;
                    break;
                  case 2:
                    width = 9.0;
                    height = 9.0;
                    break;
                  case 3:
                    width = 11.0;
                    height = 11.0;
                    break;
                  case 4:
                    width = 13.0;
                    height = 13.0;
                    break;
                  case 5:
                    width = 15.0;
                    height = 15.0;
                    break;

                }
                return Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffFFCD37)),//Change color
                  width: width,
                  height: height,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                );

              },
            )
          // This trailing comma makes auto-formatting nicer for build methods.

        )
    );
  }
}
