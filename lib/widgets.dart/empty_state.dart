import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState({super.key, this.message = 'No transactions yet'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long,
                size: 64, color: AppColors.primaryLight),
            const SizedBox(height: 12),
            Text(message,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Tap the + button to add your first one',
                style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}