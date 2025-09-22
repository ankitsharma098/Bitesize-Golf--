import 'package:bitesize_golf/features/guest%20module/profile/presentation/guest_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../components/utils/size_config.dart';
import '../../../custom bottom navigation/bloc/custom_bottom_navigation_bloc.dart';
import '../../../custom bottom navigation/bloc/custom_bottom_navigation_event.dart';
import '../../../custom bottom navigation/bloc/custom_bottom_navigation_state.dart';
import '../../../custom bottom navigation/presentation/custom_bottom_navigation.dart';
import '../../profile/data/guest_profile_bloc.dart';

class MainGuestWrapperScreen extends StatefulWidget {
  const MainGuestWrapperScreen({super.key});

  @override
  State<MainGuestWrapperScreen> createState() => _MainGuestWrapperScreenState();
}

class _MainGuestWrapperScreenState extends State<MainGuestWrapperScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(BuildContext context, int index) {
    context.read<BottomNavBloc>().add(BottomNavItemTapped(index));
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("==========>dmsds");
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBloc>(create: (_) => BottomNavBloc()),
        // BlocProvider<GuestHomeBloc>(
        //   create: (context) => GuestHomeBloc(
        //     context.read<DashboardRepository>(),
        //     context.read<AuthRepository>(),
        //   ),
        // ),
        BlocProvider<GuestProfileBloc>(
          create: (context) => GuestProfileBloc(
            // context.read<DashboardRepository>(),
            // context.read<AuthRepository>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<BottomNavBloc, BottomNavState>(
            builder: (context, state) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                extendBody: true,
                body: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<BottomNavBloc>().add(
                      BottomNavItemTapped(index),
                    );
                  },
                  children: const [
                    PlaceholderScreen(title: 'Home'),
                    PlaceholderScreen(title: 'Schedule'),
                    PlaceholderScreen(title: 'Progress'),
                    PlaceholderScreen(title: 'Awards'),
                    GuestProfilePage(),
                  ],
                ),
                bottomNavigationBar: CustomBottomNavBar(
                  currentIndex: state.selectedIndex,
                  onTap: (index) =>
                      _onTabTapped(context, index), // Pass context
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.greenDark,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: SizeConfig.scaleWidth(64),
              color: AppColors.grey600,
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Text(
              '$title Screen',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(24),
                fontWeight: FontWeight.w600,
                color: AppColors.grey900,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              'Coming soon...',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(16),
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
