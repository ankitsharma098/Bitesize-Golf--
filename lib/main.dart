// main.dart
import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bitesize_golf/route/app_router.dart';

import 'core/connectivity check/screens/internet_overlay_screen.dart';
import 'core/constants/app_constants.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/theme_provider.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/components/utils/loader_spinner.dart';
import 'firebase_options.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await configureDependencies();

  // Ensure Firebase Auth is initialized
  await FirebaseAuth.instance.authStateChanges().first;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (_) => getIt<AuthBloc>()..add(AuthAppStarted())),
      ],
      child: const AppContent(),
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppName,
          theme: themeProvider.isDarkMode
              ? AppTheme.darkTheme(context)
              : AppTheme.lightTheme(context),
          themeMode: MediaQuery.platformBrightnessOf(context) == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: AppRouter.router,
          builder: (context, child) {
            return ConnectivityOverlay(child: child ?? Container());
          },
        );
      },
    );
  }
}
