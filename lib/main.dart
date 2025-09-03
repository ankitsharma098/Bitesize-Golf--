import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'core/di/dependency_injection.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/theme_provider.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'firebase_options.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter(); // boxes are opened lazily by HiveStorageService

  await configureDependencies();
  runApp(RegisterPage());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = checkLoggedIn();
  }

  Future<bool> checkLoggedIn() => getIt<AuthLocalDataSource>().isLoggedIn();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<void>(
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
                    HexagonDotsLoader(color: Theme.of(context).canvasColor),
                    SizedBox(height: 16),
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

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Lucie',
          theme: themeProvider.isDarkMode
              ? AppTheme.darkTheme(context)
              : AppTheme.lightTheme(context),
          themeMode: MediaQuery.platformBrightnessOf(context) == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: AppRouter.router,
          // Add the connectivity overlay here
          builder: (context, child) {
            return ConnectivityOverlay(child: child ?? Container());
          },
        );
      },
    );
  }
}
