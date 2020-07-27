import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:timer_bloc_timer/bloc/timer_event.dart';
import 'package:timer_bloc_timer/bloc/timer_state.dart';
import 'package:timer_bloc_timer/tiker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const int _duration = 60;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker,
        super(TimerInitial(_duration));

  @override
  void onTransition(Transition<TimerEvent, TimerState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    yield TimerRunInProgress(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(TimerTricked(duration: duration)));
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTricked tick) async* {
    yield tick.duration > 0
        ? TimerRunInProgress(tick.duration)
        : TimerRunComplete(tick.duration);
  }

  Stream<TimerState> _mapTimerPausedToState(TimerPaused paused) async* {
    if (state is TimerRunInProgress) {
      _tickerSubscription.pause();
      yield TimerRunPause(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResumeToState(TimerResumed resume) async* {
    if (state is TimerRunPause) {
      _tickerSubscription.resume();
      yield TimerRunInProgress(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResetToState(TimerReset reset) async* {
    if(state is TimerRunInProgress){
      _tickerSubscription.cancel();
      yield TimerInitial(_duration);
    }
  }

  @override
  Stream<TimerState> mapEventToState(TimerEvent event,) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerTricked) {
      yield* _mapTimerTickedToState(event);
    } else if (event is TimerPaused) {
      yield* _mapTimerPausedToState(event);
    } else if (event is TimerResumed) {
      yield* _mapTimerResumeToState(event);
    } else if(event is TimerReset){
      yield* _mapTimerResetToState(event);
    }

    @override
    Future<void> close() {
      _tickerSubscription?.cancel();
      return super.close();
    }
  }
}
