import 'package:expense_manager/provider/transaction_provider.dart';
import 'package:expense_manager/widgets.dart/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../utils/app_theme.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _clear(BuildContext context) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Clear storage?',
      message: 'This will delete all your transactions permanently.',
      confirmText: 'Clear',
    );
    if (!ok || !context.mounted) return;
    final success = await context.read<TransactionProvider>().clearAll();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? 'Storage cleared' : 'Could not clear storage'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFBDBDBD),
                  child: Icon(Icons.person, size: 48, color: Colors.white),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt,
                        size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Sahal Muhammed',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () => _clear(context),
              child: const Text('Clear Storage'),
            ),
          ],
        ),
      ),
    );
  }
}