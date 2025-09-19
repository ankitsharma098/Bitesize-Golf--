import 'package:equatable/equatable.dart';

abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();

  @override
  List<Object> get props => [];
}

class BottomNavItemTapped extends BottomNavEvent {
  final int index;

  const BottomNavItemTapped(this.index);

  @override
  List<Object> get props => [index];
}
