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
import 'package:bitesize_golf/features/auth/data/datasources/auth_local_datasource.dart'
    as _i716;
import 'package:bitesize_golf/features/auth/data/repositories/auth_repository_impl.dart'
    as _i242;
import 'package:bitesize_golf/features/auth/domain/repositories/auth_repository.dart'
    as _i48;
import 'package:bitesize_golf/features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i601;
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
import 'package:bitesize_golf/features/auth/domain/usecases/update_coach_profile_usecase.dart'
    as _i588;
import 'package:bitesize_golf/features/auth/domain/usecases/update_pupil_profile_usecase.dart'
    as _i527;
import 'package:bitesize_golf/features/auth/presentation/bloc/auth_bloc.dart'
    as _i751;
import 'package:bitesize_golf/features/club/data/repositories/club_repository_impl.dart'
    as _i426;
import 'package:bitesize_golf/features/club/domain/repositories/golf_club_repository.dart'
    as _i755;
import 'package:bitesize_golf/features/club/domain/usecases/get_club_useCase.dart'
    as _i53;
import 'package:bitesize_golf/features/coaches/data/datasources/coach_remote_datasource.dart'
    as _i636;
import 'package:bitesize_golf/features/coaches/data/repositories/coach_repository_impl.dart'
    as _i823;
import 'package:bitesize_golf/features/coaches/domain/repositories/coach_repository.dart'
    as _i83;
import 'package:bitesize_golf/features/coaches/domain/usecases/get_all_coaches_usecase.dart'
    as _i656;
import 'package:bitesize_golf/features/coaches/domain/usecases/get_available_usecase.dart'
    as _i936;
import 'package:bitesize_golf/features/coaches/domain/usecases/get_coach_by_clubId.dart'
    as _i222;
import 'package:bitesize_golf/features/coaches/domain/usecases/get_coach_usecase_by_id.dart'
    as _i1045;
import 'package:bitesize_golf/features/coaches/domain/usecases/get_coaches_by_clubId_filter.dart'
    as _i889;
import 'package:bitesize_golf/features/coaches/domain/usecases/get_verified_coaches_usecase.dart'
    as _i1033;
import 'package:bitesize_golf/features/coaches/domain/usecases/search_coaches_usecase.dart'
    as _i263;
import 'package:bitesize_golf/features/coaches/domain/usecases/update_coach_usecase.dart'
    as _i658;
import 'package:bitesize_golf/features/coaches/domain/usecases/watch_coach_usecase.dart'
    as _i624;
import 'package:bitesize_golf/features/pupils%20modules/home/domain/usecases/get_pupil_usecase.dart'
    as _i1021;
import 'package:bitesize_golf/features/pupils%20modules/home/presentation/level%20bloc/level_dashboard_bloc.dart'
    as _i133;
import 'package:bitesize_golf/features/pupils%20modules/home/presentation/pupil%20bloc/pupil_bloc.dart'
    as _i669;
import 'package:bitesize_golf/features/pupils%20modules/level/data/datasource/level_firestore_data_sources.dart'
    as _i764;
import 'package:bitesize_golf/features/pupils%20modules/level/data/repositories/level_repo_impl.dart'
    as _i529;
import 'package:bitesize_golf/features/pupils%20modules/level/domain/repositories/level_repo.dart'
    as _i541;
import 'package:bitesize_golf/features/pupils%20modules/level/domain/usecases/get_level_by_id.dart'
    as _i226;
import 'package:bitesize_golf/features/pupils%20modules/level/domain/usecases/get_level_usecase.dart'
    as _i530;
import 'package:bitesize_golf/features/pupils%20modules/level/domain/usecases/get_levels_by_plan.dart'
    as _i113;
import 'package:bitesize_golf/features/pupils%20modules/pupil/data/repositories/pupil_repo_impl.dart'
    as _i191;
import 'package:bitesize_golf/features/pupils%20modules/pupil/domain/repositories/pupil_repo.dart'
    as _i226;
import 'package:bitesize_golf/features/pupils%20modules/pupil/domain/usecases/get_pupil_usecase.dart'
    as _i282;
import 'package:bitesize_golf/features/pupils%20modules/pupil/domain/usecases/update_pupil_usecase.dart'
    as _i101;
import 'package:bitesize_golf/features/subscription/data/data%20source/subscription_firestore_data_source.dart'
    as _i267;
import 'package:bitesize_golf/features/subscription/data/data%20source/subscription_repo_imple.dart'
    as _i238;
import 'package:bitesize_golf/features/subscription/domain/repo/subscription_repo.dart'
    as _i108;
import 'package:bitesize_golf/features/subscription/domain/usecases/load_subscription_plans.dart'
    as _i142;
import 'package:bitesize_golf/features/subscription/domain/usecases/purchase_subscription.dart'
    as _i993;
import 'package:bitesize_golf/features/subscription/presentation/subscription_bloc/subscription_bloc.dart'
    as _i531;
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
    gh.lazySingleton<_i267.SubscriptionFirebaseDataSource>(
      () => _i267.SubscriptionFirebaseDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i700.HiveStorageService>(
      () => _i700.HiveStorageServiceImpl(),
    );
    gh.lazySingleton<_i636.CoachRemoteDataSource>(
      () => _i636.CoachRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i83.CoachRepository>(
      () => _i823.CoachRepositoryImpl(gh<_i636.CoachRemoteDataSource>()),
    );
    gh.lazySingleton<_i108.SubscriptionRepository>(
      () => _i238.SubscriptionRepositoryImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
        dataSource: gh<_i267.SubscriptionFirebaseDataSource>(),
      ),
    );
    gh.lazySingleton<_i755.ClubRepository>(
      () => _i426.ClubRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i656.GetAllCoachesUseCase>(
      () => _i656.GetAllCoachesUseCase(gh<_i83.CoachRepository>()),
    );
    gh.factory<_i936.GetAvailableCoachesUseCase>(
      () => _i936.GetAvailableCoachesUseCase(gh<_i83.CoachRepository>()),
    );
    gh.factory<_i889.GetCoachesByClubWithFiltersUseCase>(
      () =>
          _i889.GetCoachesByClubWithFiltersUseCase(gh<_i83.CoachRepository>()),
    );
    gh.factory<_i222.GetCoachesByClubUseCase>(
      () => _i222.GetCoachesByClubUseCase(gh<_i83.CoachRepository>()),
    );
    gh.factory<_i1045.GetCoachUseCase>(
      () => _i1045.GetCoachUseCase(gh<_i83.CoachRepository>()),
    );
    gh.factory<_i1033.GetVerifiedCoachesUseCase>(
      () => _i1033.GetVerifiedCoachesUseCase(gh<_i83.CoachRepository>()),
    );
    gh.factory<_i263.SearchCoachesUseCase>(
      () => _i263.SearchCoachesUseCase(gh<_i83.CoachRepository>()),
    );
    gh.factory<_i658.UpdateCoachUseCase>(
      () => _i658.UpdateCoachUseCase(gh<_i83.CoachRepository>()),
    );
    gh.factory<_i624.WatchCoachUseCase>(
      () => _i624.WatchCoachUseCase(gh<_i83.CoachRepository>()),
    );
    gh.lazySingleton<_i764.LevelFirebaseDataSource>(
      () => _i764.LevelFirebaseDataSourceImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i716.AuthLocalDataSource>(
      () => _i716.AuthLocalDataSourceImpl(
        prefs: gh<_i460.SharedPreferences>(),
        hiveStorage: gh<_i700.HiveStorageService>(),
      ),
    );
    gh.lazySingleton<_i226.PupilRepository>(
      () => _i191.PupilRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i53.GetClubsUseCase>(
      () => _i53.GetClubsUseCase(gh<_i755.ClubRepository>()),
    );
    gh.lazySingleton<_i541.LevelRepository>(
      () => _i529.LevelRepositoryImpl(
        gh<_i764.LevelFirebaseDataSource>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.factory<_i101.UpdatePupilProgressUseCase>(
      () => _i101.UpdatePupilProgressUseCase(gh<_i226.PupilRepository>()),
    );
    gh.factory<_i142.LoadSubscriptionPlans>(
      () => _i142.LoadSubscriptionPlans(gh<_i108.SubscriptionRepository>()),
    );
    gh.factory<_i993.PurchaseSubscription>(
      () => _i993.PurchaseSubscription(gh<_i108.SubscriptionRepository>()),
    );
    gh.factory<_i531.SubscriptionBloc>(
      () => _i531.SubscriptionBloc(
        gh<_i142.LoadSubscriptionPlans>(),
        gh<_i993.PurchaseSubscription>(),
      ),
    );
    gh.lazySingleton<_i48.AuthRepository>(
      () => _i242.AuthRepositoryImpl(
        localDataSource: gh<_i716.AuthLocalDataSource>(),
        firestore: gh<_i974.FirebaseFirestore>(),
        firebaseAuth: gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i113.GetLevelsByPlanUseCase>(
      () => _i113.GetLevelsByPlanUseCase(gh<_i541.LevelRepository>()),
    );
    gh.factory<_i226.GetLevelByIdUseCase>(
      () => _i226.GetLevelByIdUseCase(gh<_i541.LevelRepository>()),
    );
    gh.factory<_i530.GetAllLevelsUseCase>(
      () => _i530.GetAllLevelsUseCase(gh<_i541.LevelRepository>()),
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
    gh.factory<_i588.UpdateCoachProfileUseCase>(
      () => _i588.UpdateCoachProfileUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i527.UpdatePupilProfileUseCase>(
      () => _i527.UpdatePupilProfileUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i1021.GetPupilUseCase>(
      () => _i1021.GetPupilUseCase(gh<_i48.AuthRepository>()),
    );
    gh.factory<_i282.GetPupilUseCase>(
      () => _i282.GetPupilUseCase(
        gh<_i48.AuthRepository>(),
        gh<_i226.PupilRepository>(),
      ),
    );
    gh.factory<_i133.LevelBloc>(
      () => _i133.LevelBloc(gh<_i530.GetAllLevelsUseCase>()),
    );
    gh.factory<_i751.AuthBloc>(
      () => _i751.AuthBloc(
        signInUseCase: gh<_i881.SignInUseCase>(),
        signUpUseCase: gh<_i463.SignUpUseCase>(),
        signOutUseCase: gh<_i550.SignOutUseCase>(),
        checkAuthStatusUseCase: gh<_i601.CheckAuthStatusUseCase>(),
        updateCoachProfileUseCase: gh<_i588.UpdateCoachProfileUseCase>(),
        updatePupilProfileUseCase: gh<_i527.UpdatePupilProfileUseCase>(),
        resetPasswordUseCase: gh<_i720.ResetPasswordUseCase>(),
        signInAsGuestUseCase: gh<_i361.SignInAsGuestUseCase>(),
        firebaseAuth: gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i669.PupilBloc>(
      () => _i669.PupilBloc(
        gh<_i1021.GetPupilUseCase>(),
        gh<_i101.UpdatePupilProgressUseCase>(),
      ),
    );
    gh.lazySingleton<_i433.GetCurrentUserUseCase>(
      () => _i433.GetCurrentUserUseCase(repository: gh<_i48.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i371.RegisterModule {}
