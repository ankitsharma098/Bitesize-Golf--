import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/features/components/custom_button.dart';

import '../../../components/custom_scaffold.dart';
import '../../../components/utils/size_config.dart';

class SubscriptionPage extends StatelessWidget {
  final String planName;
  final String price;
  final DateTime startDate;
  final DateTime endDate;

  const SubscriptionPage({
    super.key,
    required this.planName,
    required this.price,
    required this.startDate,
    required this.endDate,
  });

  bool get isExpiringSoon {
    final now = DateTime.now();
    return endDate.isBefore(now.add(const Duration(days: 30))) &&
        endDate.isAfter(now);
  }

  bool get isExpired {
    return endDate.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.content(
      title: "Subscription",
      showBackButton: true,
      levelType: LevelType.redLevel,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
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
                    text: isExpired ? "Expired" : "Active",
                    style: TextStyle(
                      fontSize: SizeConfig.scaleText(22),
                      fontWeight: FontWeight.bold,
                      color: isExpired ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          Center(
            child: Text(
              isExpired
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

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 2.0,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildInfoCard("Subscription Type", planName),
              _buildInfoCard("Price", price),
              _buildInfoCard("Start Date", _formatDate(startDate)),
              _buildInfoCard("End Date", _formatDate(endDate)),
            ],
          ),
          const SizedBox(height: 20),

          _buildFeatureItem("Access to all 10 golf levels"),
          _buildFeatureItem("Interactive challenges & fun games"),
          _buildFeatureItem("Progress tracking and achievements"),
          _buildFeatureItem("Access to playing stat sheets"),

          const SizedBox(height: 20),

          if (isExpired)
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red.withOpacity(0.05),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: Text(
                        "Your subscription is about to expire soon.\n"
                        "Don’t miss out on continued access! Please renew to keep enjoying all the benefits.",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                    Icon(Icons.cancel_outlined, color: Colors.red),
                  ],
                ),
              ),
            ),

          const Spacer(),
          if (isExpired)
            CustomButtonFactory.primary(
              text: "Renew Subscription",
              onPressed: () {},
              levelType: LevelType.redLevel,
            ),
        ],
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
