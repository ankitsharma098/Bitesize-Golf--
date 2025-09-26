import 'package:flutter/material.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_scaffold.dart';

class ChallengeStartPage extends StatefulWidget {
  const ChallengeStartPage({super.key});

  @override
  State<ChallengeStartPage> createState() => _ChallengeStartPageState();
}

class _ChallengeStartPageState extends State<ChallengeStartPage> {

  @override
  Widget build(BuildContext context) {
    return AppScaffold.content(
      title: "My Progress",
      showBackButton: true,
      levelType: LevelType.redLevel,
      body: Column(children: []),
    );
  }
}
