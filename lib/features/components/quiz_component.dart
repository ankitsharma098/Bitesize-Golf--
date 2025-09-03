import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class QuizQuestionCard extends StatelessWidget {
  final String question;
  final List<QuizOption> options;
  final String? selectedAnswer;
  final ValueChanged<String>? onAnswerSelected;
  final bool showResult;
  final String? correctAnswer;
  final LevelType levelType;

  const QuizQuestionCard({
    Key? key,
    required this.question,
    required this.options,
    this.selectedAnswer,
    this.onAnswerSelected,
    this.showResult = false,
    this.correctAnswer,
    required this.levelType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: 20),
          ...options.map((option) {
            bool isSelected = selectedAnswer == option.id;
            bool isCorrect = showResult && correctAnswer == option.id;
            bool isWrong =
                showResult && isSelected && correctAnswer != option.id;

            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAnswerSelected != null
                      ? () => onAnswerSelected!(option.id)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getOptionBackgroundColor(
                        isSelected,
                        isCorrect,
                        isWrong,
                      ),
                      border: Border.all(
                        color: _getOptionBorderColor(
                          isSelected,
                          isCorrect,
                          isWrong,
                        ),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getOptionIndicatorColor(
                              isSelected,
                              isCorrect,
                              isWrong,
                            ),
                            border: Border.all(
                              color: _getOptionBorderColor(
                                isSelected,
                                isCorrect,
                                isWrong,
                              ),
                              width: 2,
                            ),
                          ),
                          child: showResult
                              ? Icon(
                                  isCorrect
                                      ? Icons.check
                                      : (isWrong ? Icons.close : null),
                                  color: Colors.white,
                                  size: 16,
                                )
                              : (isSelected
                                    ? Icon(
                                        Icons.circle,
                                        color: Colors.white,
                                        size: 12,
                                      )
                                    : null),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option.text,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.grey900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getOptionBackgroundColor(
    bool isSelected,
    bool isCorrect,
    bool isWrong,
  ) {
    if (isCorrect) return AppColors.success.withOpacity(0.1);
    if (isWrong) return AppColors.error.withOpacity(0.1);
    if (isSelected) return levelType.lightColor;
    return Colors.white;
  }

  Color _getOptionBorderColor(bool isSelected, bool isCorrect, bool isWrong) {
    if (isCorrect) return AppColors.success;
    if (isWrong) return AppColors.error;
    if (isSelected) return levelType.color;
    return AppColors.grey300;
  }

  Color _getOptionIndicatorColor(
    bool isSelected,
    bool isCorrect,
    bool isWrong,
  ) {
    if (isCorrect) return AppColors.success;
    if (isWrong) return AppColors.error;
    if (isSelected) return levelType.color;
    return Colors.transparent;
  }
}

class QuizOption {
  final String id;
  final String text;

  const QuizOption({required this.id, required this.text});
}
