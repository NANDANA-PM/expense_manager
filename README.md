# expense_manager

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# Expenzia – Expense Management App

A Flutter expense manager built from the provided Figma design. All data is stored locally in **SQLite** (via `sqflite`) and persists after the app is closed and reopened.

## Setup

```bash
flutter create expenzia
cd expenzia
# replace the generated lib/ folder with this project's lib/
flutter pub add sqflite path provider intl
flutter pub get
flutter run
```

## Dependencies

- `sqflite` – SQLite storage
- `path` – database path
- `provider` – state management
- `intl` – date and number formatting

## Completed features

- Splash and onboarding screens
- Home: total balance, income, expenses, daily average, weekly total, recent transactions
- Transaction history with edit and delete (delete asks for confirmation)
- Add / edit transaction (type, name, category, amount, date, optional description)
- Form validation (required fields, amount must be a positive number)
- Empty state when there are no transactions
- List and totals update automatically after every change
- Credit screen: add and delete saved credits (stored in SQLite, validated)
- Profile screen with "Clear Storage"
- Basic database error handling (try/catch + SnackBar)

## Project structure

```
lib/
├── main.dart
├── database/      SQLite helper (CRUD)
├── models/        TransactionModel
├── providers/     TransactionProvider (state)
├── screens/       Splash, Onboarding, Home, History, Add/Edit, Credit, Profile
├── utils/         Theme, formatters
└── widgets/       Reusable widgets
```

## Known issues / incomplete

- The Credit screen has no edit option (add and delete only).
- Onboarding uses an icon in place of the Figma illustration.
- Profile name and photo are static.

## Screenshots

Add screenshots in a `screenshots/` folder and link them here.