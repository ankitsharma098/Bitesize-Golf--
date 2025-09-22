import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/themes/theme_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) => _buildNavItem(index)),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: -10,
            left: _getCurvePosition(context),
            child: Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getCurvePosition(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 5;
    double itemCenter = (currentIndex * itemWidth) + (itemWidth / 2);
    return itemCenter - 30;
  }

  Widget _buildNavItem(int index) {
    bool isSelected = currentIndex == index;

    List<String> images = [
      'assets/bottom/home.svg',
      'assets/bottom/schedule.svg',
      'assets/bottom/stats.svg',
      'assets/bottom/award.svg',
      'assets/bottom/profile.svg',
    ];

    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 50,
        height: 50,
        child: isSelected
            ? CircleAvatar(
                backgroundColor: AppColors.greenDark,
                child: SvgPicture.asset(
                  images[index],
                  width: 28,
                  height: 28,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              )
            : Container(
                padding: EdgeInsets.all(10),
                child: SvgPicture.asset(
                  images[index],
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    AppColors.grey700,
                    BlendMode.srcIn,
                  ),
                ),
              ),
      ),
    );
  }
}
