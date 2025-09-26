part of 'games_bloc.dart';

@immutable
abstract class GamesEvent extends Equatable {
  const GamesEvent();

  @override
  List<Object?> get props => [];
}

class LoadGamesEvent extends GamesEvent {
  const LoadGamesEvent();
}

class LoadGameByIdEvent extends GamesEvent {
  final String gameId;

  const LoadGameByIdEvent(this.gameId);

  @override
  List<Object?> get props => [gameId];
}

class RefreshGamesEvent extends GamesEvent {
  const RefreshGamesEvent();
}