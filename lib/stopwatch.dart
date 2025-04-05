import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late Stopwatch _stopwatch;
  late Timer _timer;
  List<Map<String, String>> _laps = [];
  Duration _previousLapTime = Duration.zero;
  late AnimationController _controller;
  late Animation<double> _animation;

  // Variabel untuk tracking waktu di background
  Duration _totalElapsedTime = Duration.zero;
  DateTime? _startTime;
  DateTime? _backgroundEnterTime;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    WidgetsBinding.instance.addObserver(this);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App masuk background
      _backgroundEnterTime = DateTime.now();
      if (_stopwatch.isRunning) {
        _pauseStopwatch();
      }
    } else if (state == AppLifecycleState.resumed) {
      // App kembali ke foreground
      if (_backgroundEnterTime != null) {
        final backgroundDuration = DateTime.now().difference(
          _backgroundEnterTime!,
        );
        _totalElapsedTime += backgroundDuration;
        _backgroundEnterTime = null;

        if (!_stopwatch.isRunning && _totalElapsedTime > Duration.zero) {
          _startStopwatch();
        }
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {});
    });
  }

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      _startTime = DateTime.now().subtract(_totalElapsedTime);
      _stopwatch.start();
      _controller.repeat();
      _startTimer();
      setState(() {});
    }
  }

  void _pauseStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _totalElapsedTime = DateTime.now().difference(_startTime!);
      _controller.stop();
      _timer.cancel();
      setState(() {});
    }
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _controller.reset();
    _laps.clear();
    _previousLapTime = Duration.zero;
    _totalElapsedTime = Duration.zero;
    _startTime = null;
    if (_timer.isActive) {
      _timer.cancel();
    }
    setState(() {});
  }

  void _lapTime() {
    final currentTime = _getCurrentElapsed();
    final lapTime = currentTime - _previousLapTime;

    setState(() {
      _laps.insert(0, {
        'lapNumber': 'Lap ${_laps.length + 1}',
        'totalTime': _formatDuration(currentTime),
        'lapTime': _formatDuration(lapTime),
      });
      _previousLapTime = currentTime;
    });
  }

  Duration _getCurrentElapsed() {
    if (_stopwatch.isRunning) {
      return _totalElapsedTime + _stopwatch.elapsed;
    }
    return _totalElapsedTime;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return "$minutes:$seconds.$milliseconds";
  }

  Color _getLapColor(int index) {
    if (_laps.length == 1) return Colors.grey[50]!;
    if (index == 0) return Colors.green[50]!;
    if (index == _laps.length - 1) return Colors.red[50]!;
    return Colors.grey[50]!;
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = _getCurrentElapsed();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: CircularProgressIndicator(
                      value: _animation.value,
                      strokeWidth: 8,
                      backgroundColor: Colors.deepPurple[100],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDuration(elapsedTime),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _stopwatch.isRunning ? "Running" : "Paused",
                        style: TextStyle(
                          color: Colors.deepPurple[400],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _stopwatch.isRunning ? _lapTime : _resetStopwatch,
                  child: Icon(
                    _stopwatch.isRunning ? Icons.flag : Icons.refresh,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.green,
                  heroTag: null,
                  elevation: 5,
                ),
                SizedBox(width: 30),
                FloatingActionButton(
                  onPressed:
                      _stopwatch.isRunning ? _pauseStopwatch : _startStopwatch,
                  child: Icon(
                    _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                  backgroundColor:
                      _stopwatch.isRunning ? Colors.orange : Colors.deepPurple,
                  heroTag: null,
                  elevation: 5,
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'LAP TIMES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    Expanded(
                      child: _laps.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 50,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'No laps recorded',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _laps.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: _getLapColor(index),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Colors.deepPurple.withOpacity(0.1),
                                      child: Text(
                                        '${_laps.length - index}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _laps[index]['lapTime']!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: index == 0
                                            ? Colors.green[800]
                                            : index == _laps.length - 1
                                                ? Colors.red[800]
                                                : Colors.black87,
                                      ),
                                    ),
                                    trailing: Text(
                                      _laps[index]['totalTime']!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
