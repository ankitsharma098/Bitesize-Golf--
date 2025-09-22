import 'package:flutter/material.dart';

import '../../features/components/custom_scaffold.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold.form(
      title: "Pending Approval",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, size: 64, color: Colors.orange),
            const SizedBox(height: 20),
            const Text("Your  account is awaiting admin approval."),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () => context.read<AuthBloc>().add(AuthSignOutRequested()),
            //   child: const Text("Logout"),
            // )
          ],
        ),
      ),
    );
  }
}
