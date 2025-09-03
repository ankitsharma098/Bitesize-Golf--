import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/components/utils/size_config.dart';
import '../services/connectivity_services.dart';

class ConnectivityOverlay extends StatefulWidget {
  final Widget child;

  const ConnectivityOverlay({super.key, required this.child});

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _showNoConnection = false;

  @override
  void initState() {
    super.initState();
    _connectivityService.initialize();
    _connectivityService.connectionStream.listen((isConnected) {
      setState(() {
        _showNoConnection = !isConnected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showNoConnection)
          Positioned.fill(
            child: NoInternetOverlay(
              onRetry: () async {
                final isConnected = await _connectivityService
                    .checkConnectivity();
                if (isConnected) {
                  setState(() {
                    _showNoConnection = false;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}

class NoInternetOverlay extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetOverlay({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // No Internet Icon
              Container(
                width: SizeConfig.screenWidth * 0.6,
                height: SizeConfig.screenHeight * 0.2,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  //shape: BoxShape.circle,
                ),
                child: Icon(CupertinoIcons.wifi_slash),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'No Internet Connection',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'Please check your internet connection and try again. Make sure you are connected to Wi-Fi or mobile data.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Retry Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    'Try Again',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
