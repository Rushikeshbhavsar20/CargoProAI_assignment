# cargoproai

Cargoproai assignment — Flutter + Firebase + GetX app with **Phone Number OTP authentication** and simple CRUD-style object management.

## ✨ Features
- Phone auth with OTP (Firebase Auth) for **Android/iOS/Web**
- Clean separation of **UI pages** and **GetX controllers**
- Reactive state (`Rx`) for lists, loading, and errors
- Simple navigation with GetX routes
- **Create/Update objects by pasting raw JSON** (current)
- CRUD operations backed by a REST API (`ApiService`)

---

## 🧩 Tech stack

- **Flutter** (Dart 3)
- **Firebase**: `firebase_core`, `firebase_auth`
- **State management & routing**: `get`
- **HTTP**: `http`
- **Phone utilities**: `phone_number`, `country_picker`
- **Testing**: `flutter_test`, `http_mock_adapter`, `mocktail`

---

## 📦 Dependencies (from `pubspec.yaml`)

```yaml
name: cargoproai
description: Cargoproai assignment.
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.4.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  get: ^4.6.6
  http: ^1.2.2
  firebase_core: ^3.3.0
  firebase_auth: ^5.1.2
  phone_number: ^2.1.0
  country_picker: ^2.0.27

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  http_mock_adapter: ^0.6.1
  mocktail: ^1.0.2

flutter:
  uses-material-design: true

