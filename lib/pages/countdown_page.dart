import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newbalance_flutter/pages/running_page.dart';
import 'package:newbalance_flutter/services/thingsboard_service.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({super.key});

  @override
  State<StatefulWidget> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  final _countdownTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(4));

  @override
  void initState(){
    super.initState();
    _countdownTimer.onStartTimer();
    var runningPage = const RunningPage();
    _countdownTimer.rawTime.listen((value) {
      if (value == 0) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => runningPage));
      }
    });
    ThingsBoardService.saveSharedAttributes(ThingsBoardService.rightFootDevice, true);
    ThingsBoardService.saveSharedAttributes(ThingsBoardService.leftFootDevice, true);
  }


  StreamBuilder<int> _buildView() {
    return StreamBuilder<int>(
      stream: _countdownTimer.rawTime,
      initialData: 4,
      builder: (context, snap) {
        final value = snap.data;
        final displayTime = StopWatchTimer.getDisplayTimeSecond(value!)[1];
        return Container(
          alignment: Alignment.center,
          color: Colors.blue,
          child: Text(
            displayTime,
            style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 140,
                color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildView(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _countdownTimer.dispose();
  }
}
