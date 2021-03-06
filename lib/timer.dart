import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_bloc_timer/bloc/timer_bloc.dart';
import 'package:timer_bloc_timer/bloc/timer_state.dart';
import 'package:timer_bloc_timer/wave.dart';
import 'bloc/timer_bloc.dart';
import 'package:timer_bloc_timer/action.dart';

class Timer extends StatelessWidget {
  static const TextStyle timerTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Timer'),
      ),
      body: Stack(
        children: [
          BackgroundWave(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(
                  child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      final String minutesStr = ((state.duration / 60) % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      final String secondsStr =
                      (state.duration % 60).floor().toString().padLeft(2, '0');
                      return Text(
                        '$minutesStr : $secondsStr',
                        style: Timer.timerTextStyle,
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<TimerBloc, TimerState>(
                buildWhen: (previousState, state) =>
                previousState.runtimeType != state.runtimeType,
                builder: (context, state) => ActionsTimer(),
              )
            ],
          )
        ],
      ),
    );
  }
}
