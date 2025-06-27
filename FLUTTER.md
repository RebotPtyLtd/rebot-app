# 📱 Flutter App Setup Guide

Welcome to the `flutter_app/` module of the Rebot App! This guide will help new developers get set up for Flutter development in this repo.

---

## 🚀 Project Structure Overview

```
rebot-app/
├── backend/             # WireMock test API
├── my-office-app/       # SvelteKit frontend
├── flutter_app/         # Flutter mobile/web client
└── docker-compose.yml   # Runs both frontend + mock API
```

---

## ✅ Prerequisites

### All Platforms
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
  - We recommend using [FVM](https://fvm.app/) (Flutter Version Manager)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- VS Code or Android Studio (with Flutter & Dart extensions)

### macOS
- Xcode (for iOS simulator)
  ```bash
  xcode-select --install
  sudo xcodebuild -license accept
  ```
- Android Studio (for Android emulator)

### Linux
- Android Studio for emulator support
- Chrome for Flutter Web

### Windows
- Android Studio (emulator)
- Enable WSL2 if using Flutter Web in Docker

---

## 📦 Flutter Setup with FVM

Install FVM globally:
```bash
dart pub global activate fvm
```

Then install the project's Flutter version:
```bash
cd flutter_app
fvm install
fvm flutter pub get
```

Use FVM to run commands:
```bash
fvm flutter doctor
fvm flutter run
```

---

## 🌍 Environment Configuration

Environment-specific `.env` files are used to configure the API URL.

| Platform        | Env File        | BASE_URL value                         |
|----------------|------------------|----------------------------------------|
| Android        | `.env.mobile`    | `http://10.0.2.2:8080/api`             |
| iOS Simulator  | `.env.mobile`    | `http://localhost:8080/api`            |
| Web (Chrome)   | `.env.web`       | `http://localhost:5173/api` *(via proxy)* |
| macOS Desktop  | `.env`           | `http://localhost:8080/api`            |

These files are loaded automatically by `flutter_dotenv` in `main.dart`.

> **Note:** Do not commit `.env*` files — they are gitignored.

---

## ▶️ Running the App

### Run on iOS Simulator (macOS only):
```bash
open -a Simulator
fvm flutter run -d ios
```

### Run on Android Emulator:
```bash
fvm flutter emulators
fvm flutter emulators --launch <emulator_id>
fvm flutter run -d android
```

### Run on Chrome/Web:
```bash
fvm flutter run -d chrome
```

### Run on macOS Desktop:
```bash
fvm flutter run -d macos
```

---

## 🧪 Troubleshooting

- Make sure WireMock API is running (`docker-compose up`)
- Use `10.0.2.2` for Android to reach host `localhost`
- Use your local IP for both iOS & Android if needed
  ```bash
  ipconfig getifaddr en0  # macOS only
  ```
- `.env` file not found? Double-check platform detection logic in `main.dart`

---

## 📁 Related Files
- `lib/api.dart`: API client
- `lib/main.dart`: App entry point with `.env` loader
- `.env*`: Environment configs

---

Happy coding! 🎯
