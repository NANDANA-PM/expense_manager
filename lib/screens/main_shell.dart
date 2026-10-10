import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import 'add_edit_transaction_screen.dart';
import 'credit_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _openAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTransactionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onSeeAll: () => setState(() => _index = 1)),
      const HistoryScreen(),
      const CreditScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(
            side: BorderSide(color: Colors.white, width: 3)),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primary,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        height: 60,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navIcon(Icons.home_outlined, 0),
            _navIcon(Icons.history, 1),
            const SizedBox(width: 48),
            _navIcon(Icons.account_balance_wallet_outlined, 2),
            _navIcon(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int i) {
    final selected = _index == i;
    return IconButton(
      onPressed: () => setState(() => _index = i),
      icon: Icon(icon,
          color: selected ? Colors.white : Colors.white54, size: 26),
    );
  }
}