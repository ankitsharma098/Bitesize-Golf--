import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../../Models/game models/game_model.dart';
part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  StreamSubscription? _gamesSubscription;

  GamesBloc() : super(GamesInitial()) {
    on<LoadGamesEvent>(_onLoadGames);
    on<LoadGameByIdEvent>(_onLoadGameById);
    on<RefreshGamesEvent>(_onRefreshGames);
    on<_UpdateGamesData>(_onUpdateGamesData);
  }

  Future<void> _onLoadGames(LoadGamesEvent event, Emitter<GamesState> emit) async {
    emit(GamesLoading());
    try {
      await _startListeningToGamesUpdates();
    } catch (e) {
      debugPrint("Error loading games: $e");
      emit(GamesError('Failed to load games: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshGames(RefreshGamesEvent event, Emitter<GamesState> emit) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('games')
          .get();

      if (querySnapshot.docs.isEmpty) {
        emit(GamesEmpty('No games available'));
        return;
      }

      final games = querySnapshot.docs
          .map((doc) => GameModel.fromFirestore(doc.data()))
          .toList();

      emit(GamesLoaded(games: games));
    } catch (e) {
      debugPrint("Error refreshing games: $e");
      emit(GamesError('Failed to refresh games: ${e.toString()}'));
    }
  }

  Future<void> _onLoadGameById(LoadGameByIdEvent event, Emitter<GamesState> emit) async {
    emit(GamesLoading());
    try {
      // Validate gameId
      if (event.gameId.isEmpty) {
        emit(GamesError('Game ID cannot be empty'));
        return;
      }

      debugPrint("Loading game with ID: ${event.gameId}");

      final doc = await FirebaseFirestore.instance
          .collection('games')
          .doc(event.gameId)
          .get();

      debugPrint("Document exists: ${doc.exists}");

      if (!doc.exists) {
        emit(GamesError('Game not found with ID: ${event.gameId}'));
        return;
      }

      final data = doc.data();
      if (data == null) {
        emit(GamesError('Game data is null'));
        return;
      }

      debugPrint("Game data: $data");

      final game = GameModel.fromFirestore(data);
      debugPrint("Game loaded successfully: ${game.title}");

      emit(GameDetailsLoaded(game));
    } catch (e) {
      debugPrint("Error loading game by ID: $e");
      debugPrint("Error type: ${e.runtimeType}");
      emit(GamesError('Failed to load game: ${e.toString()}'));
    }
  }

  void _onUpdateGamesData(
      _UpdateGamesData event,
      Emitter<GamesState> emit,
      ) {
    if (event.error != null) {
      emit(GamesError(event.error!));
    } else if (event.games != null) {
      if (event.games!.isEmpty) {
        emit(GamesEmpty('No games available'));
      } else {
        emit(GamesLoaded(games: event.games!));
      }
    }
  }

  Future<void> _startListeningToGamesUpdates() async {
    await _gamesSubscription?.cancel();

    _gamesSubscription = FirebaseFirestore.instance
        .collection('games')
        .snapshots()
        .listen(
          (querySnapshot) {
        try {
          final games = querySnapshot.docs
              .map((doc) => GameModel.fromFirestore(doc.data()))
              .toList();
          add(_UpdateGamesData(games: games));
        } catch (e) {
          debugPrint("Error parsing games data: $e");
          add(_UpdateGamesData(error: 'Failed to parse games data: ${e.toString()}'));
        }
      },
      onError: (error) {
        debugPrint("Error listening to games updates: $error");
        add(_UpdateGamesData(error: 'Failed to load games: ${error.toString()}'));
      },
    );
  }

  @override
  Future<void> close() {
    _gamesSubscription?.cancel();
    return super.close();
  }
}

class _UpdateGamesData extends GamesEvent {
  final List<GameModel>? games;
  final String? error;

  const _UpdateGamesData({this.games, this.error});

  @override
  List<Object?> get props => [games, error];
}