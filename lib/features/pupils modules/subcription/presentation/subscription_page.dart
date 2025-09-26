import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Models/subscription model/subscription.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/size_config.dart';
import '../data/subscription_bloc.dart';

class SubscriptionPage extends StatelessWidget {
  final String userId;

  const SubscriptionPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionBloc()..add(LoadSubscription(userId)),
      child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading || state is SubscriptionInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubscriptionError) {
            return AppScaffold.content(
              title: "Subscription",
              showBackButton: true,
              levelType: LevelType.redLevel,
              body: Center(child: Text(state.message)),
            );
          }

          if (state is SubscriptionLoaded) {
            final sub = state.subscription;

            return AppScaffold.content(
              title: "Subscription",
              showBackButton: true,
              levelType: LevelType.redLevel,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Subscription Status
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Subscription ",
                        style: TextStyle(
                          color: AppColors.grey900,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.scaleText(22),
                        ),
                        children: [
                          TextSpan(
                            text: sub.isExpired
                                ? "Expired"
                                : (sub.isActive ? "Active" : sub.status.name),
                            style: TextStyle(
                              fontSize: SizeConfig.scaleText(22),
                              fontWeight: FontWeight.bold,
                              color: sub.isExpired ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      sub.isExpired
                          ? "Your subscription has expired.\nPlease renew to continue."
                          : "Thank you for being a member!\nYour subscription is active.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey900,
                        fontSize: SizeConfig.scaleText(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Subscription Info Cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 2.0,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildInfoCard(
                        "Tier",
                        sub.tier.name.toUpperCase(),
                      ), // free/premium
                      _buildInfoCard(
                        "Auto Renew",
                        sub.autoRenew ? "Enabled" : "Disabled",
                      ),
                      _buildInfoCard(
                        "Start Date",
                        sub.startDate != null
                            ? _formatDate(sub.startDate!)
                            : "N/A",
                      ),
                      _buildInfoCard(
                        "End Date",
                        sub.endDate != null ? _formatDate(sub.endDate!) : "N/A",
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Features
                  _buildFeatureItem(
                    "Unlock up to ${sub.maxUnlockedLevels} golf levels",
                  ),
                  _buildFeatureItem("Interactive challenges & fun games"),
                  _buildFeatureItem("Progress tracking and achievements"),
                  _buildFeatureItem("Access to playing stat sheets"),

                  const Spacer(),

                  // Renew Button
                  if (sub.isExpired)
                    CustomButtonFactory.primary(
                      text: "Renew Subscription",
                      onPressed: () {
                        context.read<SubscriptionBloc>().add(
                          RenewSubscription(userId),
                        );
                      },
                      levelType: LevelType.redLevel,
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd MMM yyyy").format(date);
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.scaleWidth(6)),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(12),
        vertical: SizeConfig.scaleHeight(10),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(20)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig.scaleText(12),
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(4)),
          Text(
            value,
            style: TextStyle(
              fontSize: SizeConfig.scaleText(14),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
