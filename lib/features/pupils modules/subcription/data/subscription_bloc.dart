// subscription_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../Models/pupil model/pupil_model.dart';
import '../../../../Models/subscription model/subscription.dart';
import '../../../../core/constants/firebase_collections_names.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<LoadSubscription>(_onLoadSubscription);
    on<RefreshSubscription>(_onRefreshSubscription);
    on<RenewSubscription>(_onRenewSubscription);
  }

  Future<void> _onLoadSubscription(
    LoadSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      final doc = await FirestoreCollections.pupilsCol.doc(event.userId).get();

      if (!doc.exists) {
        emit(SubscriptionError("Pupil not found"));
        return;
      }

      final pupil = PupilModel.fromFirestore(doc.data()!);
      if (pupil.subscription == null) {
        emit(SubscriptionError("No subscription found"));
        return;
      }

      emit(SubscriptionLoaded(pupil.subscription!));
    } catch (e) {
      emit(SubscriptionError("Failed to load subscription: $e"));
    }
  }

  Future<void> _onRefreshSubscription(
    RefreshSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    add(LoadSubscription(event.userId));
  }

  Future<void> _onRenewSubscription(
    RenewSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      final newEndDate = DateTime.now().add(const Duration(days: 365));

      await FirestoreCollections.pupilsCol.doc(event.userId).update({
        'subscription.endDate': Timestamp.fromDate(newEndDate),
        'subscription.startDate': Timestamp.fromDate(DateTime.now()),
      });

      emit(SubscriptionRenewed());
      add(LoadSubscription(event.userId));
    } catch (e) {
      emit(SubscriptionError("Failed to renew subscription: $e"));
    }
  }
}
