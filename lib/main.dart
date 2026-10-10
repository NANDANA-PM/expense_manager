import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_manager/provider/transaction_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionProvider()..load(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenzia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}

// import 'package:expense_manager/provider/transaction_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// import 'screens/splash_screen.dart';
// import 'utils/app_theme.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => TransactionProvider()..load(),
//       child: MaterialApp(
//         title: 'Expenzia',
//         debugShowCheckedModeBanner: false,
//         theme: AppTheme.light,
//         home: const SplashScreen(),
//       ),
//     ),
//   );
// }