import 'package:flutter/material.dart';
import '../services/connectivity_services.dart';

class ConnectivityStatusBar extends StatefulWidget {
  const ConnectivityStatusBar({super.key});

  @override
  State<ConnectivityStatusBar> createState() => _ConnectivityStatusBarState();
}

class _ConnectivityStatusBarState extends State<ConnectivityStatusBar>
    with SingleTickerProviderStateMixin {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _connectivityService.connectionStream.listen((isConnected) {
      setState(() {
        _isConnected = isConnected;
      });

      if (!isConnected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - _animationController.value)),
          child: Container(
            height: _isConnected ? 0 : 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child:
                _isConnected
                    ? null
                    : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off,
                            color: Theme.of(context).colorScheme.onError,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'No Internet Connection',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onError,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }
}
