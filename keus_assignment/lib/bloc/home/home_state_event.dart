part of 'home_state_bloc.dart';

sealed class HomeStateEvent {}

class RefreshHomeEvent extends HomeStateEvent {}

class FilterEvent extends HomeStateEvent {
  final Filter filter;

  FilterEvent({required this.filter});
}
