import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../../route/navigator_service.dart';
import '../../../../route/routes_names.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_scaffold.dart';

class StatisticsWelcomeScreen extends StatelessWidget {
  const StatisticsWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold.content(
      title: "Statistic",
      showBackButton: true,
      levelType: LevelType.redLevel,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome\nto Statistics",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Track your pupils' progress and improve their game:\n\n"
                        "• Review stats: See their performance over time.\n"
                        "• Spot trends: Identify areas for improvement.\n"
                        "• Monitor club performance: Check which clubs they use best.\n"
                        "• Target your next coaching sessions where they will have the most impact.\n\n"
                        "Select a pupil to view detailed stats and create training goals.",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14, color:AppColors.grey900),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    "assets/stats/Level=red.png",
                    height: 100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButtonFactory.primary(
              text: "View Pupil Stats",
              onPressed: () {
                NavigationService.push(RouteNames.pupilstats);
              },
              levelType: LevelType.redLevel,
            ),
            const SizedBox(height: 12),
            CustomButtonFactory.faded(
              text: "View Level Stats",
              onPressed: () {
                context.go(RouteNames.guestHome);
              },
              levelType: LevelType.redLevel,
            ),
          ],
        ),
      ),
    );
  }
}
