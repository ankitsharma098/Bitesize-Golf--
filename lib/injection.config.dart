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
import 'package:bitesize_golf/features/club/data/repositories/club_repository.dart'
    as _i652;
import 'package:bitesize_golf/features/pupils%20modules/pupil/data/repositories/pupil_repo.dart'
    as _i906;
import 'package:bitesize_golf/features/subscription/data/data%20source/subscription_repo.dart'
    as _i395;
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
    gh.lazySingleton<_i700.HiveStorageService>(
      () => _i700.HiveStorageServiceImpl(),
    );
    gh.lazySingleton<_i652.ClubRepository>(
      () => _i652.ClubRepository(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i395.SubscriptionRepository>(
      () => _i395.SubscriptionRepository(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i906.PupilRepository>(
      () => _i906.PupilRepository(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i531.SubscriptionBloc>(
      () => _i531.SubscriptionBloc(gh<_i395.SubscriptionRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i371.RegisterModule {}
