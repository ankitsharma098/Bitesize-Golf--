// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bitesize_golf/core/di/dependency_injection.dart' as _i371;
import 'package:bitesize_golf/core/storage/hive_storage_services.dart' as _i700;
import 'package:bitesize_golf/features/auth/data/datasources/auth_firebase_datasource.dart'
    as _i173;
import 'package:bitesize_golf/features/auth/data/datasources/auth_local_datasource.dart'
    as _i716;
import 'package:bitesize_golf/features/auth/data/repositories/auth_repository_impl.dart'
    as _i242;
import 'package:bitesize_golf/features/auth/domain/repositories/auth_repository.dart'
    as _i48;
import 'package:bitesize_golf/features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i601;
import 'package:bitesize_golf/features/auth/domain/usecases/create_coach_profile_usecase.dart'
    as _i874;
import 'package:bitesize_golf/features/auth/domain/usecases/create_pupil_profile_usecase.dart'
    as _i791;
import 'package:bitesize_golf/features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i433;
import 'package:bitesize_golf/features/auth/domain/usecases/reset_password_usecase.dart'
    as _i720;
import 'package:bitesize_golf/features/auth/domain/usecases/sign_in_guest_usecase.dart'
    as _i361;
import 'package:bitesize_golf/features/auth/domain/usecases/sign_in_usecase.dart'
    as _i881;
import 'package:bitesize_golf/features/auth/domain/usecases/sign_out_usecase.dart'
    as _i550;
import 'package:bitesize_golf/features/auth/domain/usecases/sign_up_usecase.dart'
    as _i463;
import 'package:bitesize_golf/features/auth/presentation/bloc/auth_bloc.dart'
    as _i751;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_analytics/firebase_analytics.dart' as _i398;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i398.FirebaseAnalytics>(() => registerModule.analytics);
    gh.lazySingleton<_i700.HiveStorageService>(
      () => _i700.HiveStorageServiceImpl(),
    );
    gh.lazySingleton<_i716.AuthLocalDataSource>(
      () => _i716.AuthLocalDataSourceImpl(
        prefs: gh<_i460.SharedPreferences>(),
        hiveStorage: gh<_i700.HiveStorageService>(),
      ),
    );
    gh.lazySingleton<_i173.AuthFirebaseDataSource>(
      () => _i173.AuthFirebaseDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i48.AuthRepository>(
      () => _i242.AuthRepositoryImpl(
        localDataSource: gh<_i716.AuthLocalDataSource>(),
        firestore: gh<_i974.FirebaseFirestore>(),
        firebaseAuth: gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i601.CheckAuthStatusUseCase>(
      () => _i601.CheckAuthStatusUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i720.ResetPasswordUseCase>(
      () => _i720.ResetPasswordUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i361.SignInAsGuestUseCase>(
      () => _i361.SignInAsGuestUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i881.SignInUseCase>(
      () => _i881.SignInUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i550.SignOutUseCase>(
      () => _i550.SignOutUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i463.SignUpUseCase>(
      () => _i463.SignUpUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i874.CreateCoachProfileUseCase>(
      () => _i874.CreateCoachProfileUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i791.CreatePupilProfileUseCase>(
      () => _i791.CreatePupilProfileUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i751.AuthBloc>(
      () => _i751.AuthBloc(
        signInUseCase: gh<_i881.SignInUseCase>(),
        signUpUseCase: gh<_i463.SignUpUseCase>(),
        signOutUseCase: gh<_i550.SignOutUseCase>(),
        checkAuthStatusUseCase: gh<_i601.CheckAuthStatusUseCase>(),
        createCoachProfileUseCase: gh<_i874.CreateCoachProfileUseCase>(),
        createPupilProfileUseCase: gh<_i791.CreatePupilProfileUseCase>(),
        resetPasswordUseCase: gh<_i720.ResetPasswordUseCase>(),
        signInAsGuestUseCase: gh<_i361.SignInAsGuestUseCase>(),
        firebaseAuth: gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i433.GetCurrentUserUseCase>(
      () => _i433.GetCurrentUserUseCase(repository: gh<_i48.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i371.RegisterModule {}
