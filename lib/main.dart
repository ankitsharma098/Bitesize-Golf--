import 'package:bitesize_golf/route/app_router.dart';
import 'package:bitesize_golf/route/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'core/connectivity check/screens/internet_overlay_screen.dart';
import 'core/constants/app_constants.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/theme_provider.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/components/utils/loader_spinner.dart';
import 'firebase_options.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter(); // Boxes are opened lazily by HiveStorageService

  await configureDependencies();
  runApp(const MyApp()); // Run MyApp instead of RegisterPage
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = checkLoggedIn();
  }

  Future<bool> checkLoggedIn() => getIt<AuthLocalDataSource>().isLoggedIn();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return FutureBuilder<bool>(
            future: _initializationFuture,
            builder: (context, snapshot) {
              // Loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: themeProvider.isDarkMode
                      ? AppTheme.darkTheme(context)
                      : AppTheme.lightTheme(context),
                  home: Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const LoadingSpinner(),
                          const SizedBox(height: 16),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Determine initial route based on login status
              final initialRoute = snapshot.data == true
                  ? RouteNames.mainScreen
                  : RouteNames.login;

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: AppName,
                theme: themeProvider.isDarkMode
                    ? AppTheme.darkTheme(context)
                    : AppTheme.lightTheme(context),
                themeMode:
                    MediaQuery.platformBrightnessOf(context) == Brightness.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                routerConfig: AppRouter.router,
                builder: (context, child) {
                  return ConnectivityOverlay(child: child ?? Container());
                },
              );
            },
          );
        },
      ),
    );
  }
}
