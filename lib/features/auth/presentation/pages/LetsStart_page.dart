import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../components/custom_button.dart';
import '../../../components/utils/size_config.dart';
import '../../../components/custom_scaffold.dart';

class LetsStart extends StatelessWidget {
  final bool isPupil;
  const LetsStart({super.key, required this.isPupil});

  void _handleContinue(BuildContext context) {
    // Navigate to next screen - replace with your route
    // context.push('/next-screen');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.form(
      title: 'Let\'s get started',
      showBackButton: true,
      scrollable:
          false, // ONLY CHANGE: Set to false to fix Expanded layout error
      levelType: LevelType.redLevel,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: SizeConfig.scaleHeight(60)),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* ---- Logo ---- */
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(child: Image.asset("assets/logo/logo.png")),
                ),

                SizedBox(height: SizeConfig.scaleHeight(40)),

                /* ---- Welcome Text ---- */
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: SizeConfig.scaleWidth(32),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                Text(
                  'to Bitesize Golf',
                  style: TextStyle(
                    fontSize: SizeConfig.scaleWidth(32),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: SizeConfig.scaleHeight(24)),

                /* ---- Description Text ---- */
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.scaleWidth(24),
                  ),
                  child: Text(
                    'This app brings you the most exciting development programme in junior golf. It\'s great to have you as part of the team.\nNow let\'s get started',
                    style: TextStyle(
                      fontSize: SizeConfig.scaleWidth(16),
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: SizeConfig.scaleHeight(32)),

          /* ---- Continue Button ---- */
          CustomButtonFactory.primary(
            text: 'Continue',
            onPressed: () => _handleContinue(context),
            levelType: LevelType.redLevel,
          ),

          SizedBox(height: SizeConfig.scaleHeight(32)),
        ],
      ),
    );
  }
}
