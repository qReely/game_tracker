import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class FetchScheduleGames extends ScheduleEvent {
  final int year;
  final int month;
  final String ordering;

  const FetchScheduleGames({
    required this.year,
    required this.month,
    this.ordering = '-released',
  });

  @override
  List<Object> get props => [year, month, ordering];
}

class LoadNextSchedulePage extends ScheduleEvent {}
