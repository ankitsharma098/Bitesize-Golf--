part of 'challenges_bloc.dart';

@immutable
sealed class ChallengesState {}

final class ChallengesInitial extends ChallengesState {}
final class ChallengesLoading extends ChallengesState {}
