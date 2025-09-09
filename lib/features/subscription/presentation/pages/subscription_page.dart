// Updated Subscription Screen with new event names
import 'package:bitesize_golf/injection.dart';
import 'package:bitesize_golf/route/navigator_service.dart';
import 'package:bitesize_golf/route/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../subscription_bloc/subscription_bloc.dart';
import '../subscription_bloc/subscription_event.dart';
import '../subscription_bloc/subscription_state.dart';

class SubscriptionScreen extends StatelessWidget {
  final String? pupilId; // Pass this from wherever you navigate from

  const SubscriptionScreen({super.key, this.pupilId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SubscriptionBloc>()..add(LoadSubscriptionPlansEvent()),
      child: SubscriptionScreenView(pupilId: pupilId),
    );
  }
}

class SubscriptionScreenView extends StatelessWidget {
  final String? pupilId;

  const SubscriptionScreenView({super.key, this.pupilId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Subscription',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
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
            // Navigate back or to main screen
            NavigationService.push(RouteNames.letStart);
          } else if (state is SubscriptionPurchaseFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Purchase failed: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is SubscriptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
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
              //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
              // Inside SubscriptionScreenView.build, replace the Expanded + Padding part
              //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
              Expanded(
                child: LayoutBuilder(
                  // 1. know available width
                  builder: (_, constraints) {
                    return SingleChildScrollView(
                      // 2. vertical scrolling
                      child: ConstrainedBox(
                        // 3. keep content full-width
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          // 4. let Column size itself
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Text(
                                    'Choose your Subscription',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                /*  all your existing state-handling widgets  */
                                if (state is SubscriptionLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if (state is SubscriptionError)
                                  //_buildError(state, context)
                                  SizedBox()
                                else if (state is SubscriptionPlansLoaded)
                                  _buildPlanSelection(
                                    context,
                                    state,
                                  ) // Wrap version from previous answer
                                else if (state is SubscriptionPurchasing)
                                  _buildPurchasingState(state),

                                const SizedBox(height: 30),
                                _buildFeatureList(),
                                const Spacer(), // pushes button to bottom when room exists
                                _buildContinueButton(context, state),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlanSelection(
    BuildContext context,
    SubscriptionPlansLoaded state,
  ) {
    final maxCardWidth =
        (MediaQuery.of(context).size.width - 64) /
        2; // 64 = 20+20 padding + Wrap spacing

    return Wrap(
      spacing: 16, // horizontal gap between cards
      runSpacing: 12, // vertical gap if they wrap to the next line
      children: state.plans.map((plan) {
        final isSelected = state.selectedPlan == plan;

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxCardWidth),
          child: GestureDetector(
            onTap: () => context.read<SubscriptionBloc>().add(
              SelectSubscriptionPlan(plan),
            ),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.red : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? Colors.red.withOpacity(0.05)
                        : Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        plan.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plan.price,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${plan.unlockedLevels} levels',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (plan.saveText.isNotEmpty)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        plan.saveText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (isSelected)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPurchasingState(SubscriptionPurchasing state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue.withOpacity(0.05),
      ),
      child: Row(
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Processing ${state.selectedPlan.title} subscription...',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildFeatureItem('Access to premium golf levels'),
        _buildFeatureItem('Interactive challenges & fun games'),
        _buildFeatureItem('Progress tracking and achievements'),
        _buildFeatureItem('Designed by top junior golf coaches'),
        _buildFeatureItem('Video lessons and tutorials'),
        _buildFeatureItem('Coach feedback system'),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, SubscriptionState state) {
    bool isLoading = state is SubscriptionPurchasing;
    bool canPurchase =
        state is SubscriptionPlansLoaded && state.selectedPlan != null;

    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading || !canPurchase
            ? null
            : () {
                if (pupilId != null) {
                  context.read<SubscriptionBloc>().add(
                    PurchaseSubscriptionEvent(pupilId!),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pupil ID required for subscription'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? Colors.grey : Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Processing...',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              )
            : Text(
                canPurchase && state is SubscriptionPlansLoaded
                    ? 'Continue with ${state.selectedPlan!.title}'
                    : 'Continue',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }
}
