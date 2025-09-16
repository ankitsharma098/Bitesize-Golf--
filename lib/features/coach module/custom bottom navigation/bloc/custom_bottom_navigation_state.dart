import 'package:equatable/equatable.dart';

class BottomNavState extends Equatable {
  final int selectedIndex;

  const BottomNavState({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}
