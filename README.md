# SpendSmart 💰

A personal expense tracking mobile application built with Flutter, designed to give users a clean, fast, and free way to track income, expenses, budgets, and spending habits.

This is the **Flutter frontend** of SpendSmart. The backend (FastAPI + PostgreSQL) lives in a separate repo: [spendsmart-backend](https://github.com/snippetbyparth/spendsmart-backend).

---

## 📱 Overview

Most budgeting apps are either too complex or locked behind a paywall. SpendSmart solves that with a simple, mobile-first experience that gives instant clarity over your finances — completely free.

---

## ✨ Features

- **Authentication** — Register and login backed by a real API with JWT-based sessions
- **Dashboard** — Live balance overview with income/expense breakdown, calculated dynamically from real transaction data
- **Transactions** — Add, view, and filter transactions (All / Income / Expense), sorted by most recent
- **Budgets** — Set category limits with visual progress bars and over-budget warnings (80%+ threshold)
- **Reports** — Pie chart for spending by category and bar chart for weekly spending trends
- **Drawer & Navigation** — Bottom nav across Dashboard, Transactions, Budget, and Reports, plus a side drawer with profile, settings, and logout
- **Theming** — Dark/light mode toggle

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod (`AsyncNotifierProvider`, `StateNotifierProvider`) |
| HTTP Client | Dio |
| Charts | fl_chart |
| Backend | [FastAPI + PostgreSQL](https://github.com/snippetbyparth/spendsmart-backend) |

---

## 📂 Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart          # bottom nav container
│   ├── dashboard_screen.dart
│   ├── transaction_screen.dart
│   ├── budget_screen.dart
│   ├── reports_screen.dart
│   └── settings_screen.dart
├── widgets/
│   └── add_transaction_sheet.dart
├── providers/
│   ├── transaction_provider.dart
│   └── theme_provider.dart
└── services/
    ├── api_services.dart
    └── user_session.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Android emulator / iOS simulator / physical device
- The [SpendSmart backend](https://github.com/snippetbyparth/spendsmart-backend) running locally (or deployed)

### Setup

```bash
git clone https://github.com/snippetbyparth/spendsmart.git
cd spendsmart
flutter pub get
flutter run
```

### Connecting to the backend

By default the app points to a local backend at:

```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

> Note: `10.0.2.2` is the special loopback address Android emulators use to reach `localhost` on the host machine. Update this to your deployed backend URL for production builds.

---

## 🗺️ Roadmap

- [ ] Budget categories tied directly to transactions (currently matched by title)
- [ ] Full theme-aware color system across all screens
- [ ] Deploy backend to Render and point production builds at it
- [ ] Build and ship an APK release

---

## 👤 Author

**Parth Arora** — [@snippetbyparth](https://github.com/snippetbyparth)
