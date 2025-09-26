import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/shared_preference_utils.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../components/custom_button.dart';
import '../auth_subscription_bloc/auth_subscription_bloc.dart';
import '../auth_subscription_bloc/auth_subscription_event.dart';
import '../auth_subscription_bloc/auth_subscription_state.dart';

import '../../../../route/navigator_service.dart';
import '../../../../route/routes_names.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionBloc()..add(LoadSubscriptionPlansEvent()),
      child: const SubscriptionScreenView(),
    );
  }
}

class SubscriptionScreenView extends StatelessWidget {
  const SubscriptionScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Subscription',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(color: AppColors.grey100,borderRadius: BorderRadius.circular(5))
                ,child: const Icon(Icons.close, color: Colors.black)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionPurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Subscription activated! You now have access to ${state.newSubscription.maxUnlockedLevels} levels.',
                ),
                backgroundColor: Colors.green,
              ),
            );
            NavigationService.push('${RouteNames.letsStart}?isPupil=true');
          } else if (state is SubscriptionPurchaseFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Purchase failed: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SubscriptionPurchasing;
          final canPurchase =
              state is SubscriptionPlansLoaded && state.selectedPlan != null;

          return Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/golf_family.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Choose your Subscription',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (state is SubscriptionLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (state is SubscriptionPlansLoaded)
                        _buildPlanSelection(context, state),

                      const SizedBox(height: 30),
                      _buildFeatureList(),
                      const Spacer(),

                      SizedBox(
                        width: double.infinity,
                        child: CustomButtonFactory.primary(
                          text: isLoading ? 'Processing...' : 'Continue',
                          onPressed: isLoading || !canPurchase
                              ? null
                              : () async {
                            final userId =
                            await SharedPrefsService.getUserId();
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'User ID required for subscription'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }
                            context.read<SubscriptionBloc>().add(
                              PurchaseSubscriptionEvent(userId),
                            );
                          },
                          levelType: LevelType.redLevel,
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlanSelection(
      BuildContext context, SubscriptionPlansLoaded state) {
    final maxCardWidth = (MediaQuery.of(context).size.width - 64) / 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: state.plans.map((plan) {
        final isSelected = state.selectedPlan == plan;

        return GestureDetector(
          onTap: () => context.read<SubscriptionBloc>().add(
            SelectSubscriptionPlan(plan),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 160, // 👈 thoda bada width diya
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.red : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      plan.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plan.price,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              if (plan.saveText.isNotEmpty)
                Positioned(
                  top: -12,
                  right: -18,
                  child: Transform.rotate(
                    angle: -12,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        plan.saveText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              if (isSelected)
                const Positioned(
                  top: 8,
                  left: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );

  }

  Widget _buildFeatureList() {
    final features = [
      'Access to all 10 golf levels',
      'Interactive challenges & fun games',
      'Progress tracking and achievements',
      'Designed by top junior golf coaches',
    ];

    return Column(
      children: features.map((f) => _buildFeatureItem(f)).toList(),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
