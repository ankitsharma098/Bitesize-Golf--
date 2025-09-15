import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'custom_bottom_navigation_event.dart';
import 'custom_bottom_navigation_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState(selectedIndex: 0)) {
    on<BottomNavItemTapped>(_onBottomNavItemTapped);
  }

  void _onBottomNavItemTapped(
    BottomNavItemTapped event,
    Emitter<BottomNavState> emit,
  ) {
    emit(BottomNavState(selectedIndex: event.index));
  }
}
