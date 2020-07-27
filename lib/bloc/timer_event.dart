import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  final int duration;

  const TimerStarted({@required this.duration});

  @override
  String toString() => 'TimerStarted { duration: $duration }';
}

class TimerPaused extends TimerEvent {}

class TimerResumed extends TimerEvent {}

class TimerReset extends TimerEvent {}

class TimerTricked extends TimerEvent {
  final int duration;

  const TimerTricked({@required this.duration});

  @override
  List<Object> get props => [duration];

  @override
  String toString() => 'TimerTricked { duration: $duration }';
}
