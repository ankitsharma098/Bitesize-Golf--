// features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String role; // pupil | coach | admin
  final String accountStatus;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.role = 'pupil',
    this.accountStatus = 'active',
    this.emailVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPupil => role == 'pupil';
  bool get isCoach => role == 'coach';
  bool get isAdmin => role == 'admin';
  bool get isGuest => role == 'guest';

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoURL,
    role,
    accountStatus,
    emailVerified,
    createdAt,
    updatedAt,
  ];

  // Copy with for immutability
  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? role,
    bool? emailVerified,
    String? accountStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    photoURL: photoURL ?? this.photoURL,
    role: role ?? this.role,
    accountStatus: role ?? this.accountStatus,
    emailVerified: emailVerified ?? this.emailVerified,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
