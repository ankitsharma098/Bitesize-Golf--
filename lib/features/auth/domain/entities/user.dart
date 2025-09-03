// features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  /// 'guest' | 'pupil' | 'coach' | 'admin'
  final String role;

  final bool emailVerified;

  const User({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.role = 'pupil',
    this.emailVerified = false,
  });

  bool get isGuest => role == 'guest';
  bool get isPupil => role == 'pupil';
  bool get isCoach => role == 'coach';
  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    role,
    emailVerified,
  ];
}
