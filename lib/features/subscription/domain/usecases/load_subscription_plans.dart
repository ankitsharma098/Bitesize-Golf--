// features/subscription/domain/usecases/load_subscription_plans.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../failure.dart';
import '../../data/model/subscription.dart';
import '../../presentation/subscription_bloc/subscription_state.dart';
import '../repo/subscription_repo.dart';

@injectable
class LoadSubscriptionPlans {
  final SubscriptionRepository repository;

  LoadSubscriptionPlans(this.repository);

  Future<Either<Failure, List<SubscriptionPlan>>> call() async {
    return await repository.getAvailablePlans();
  }
}
