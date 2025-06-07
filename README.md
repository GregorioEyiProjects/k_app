# Kh App

A Flutter application for appointment booking and billing management.

## Kh app
![Home page](./screenshots/airbnb.jpeg)

## Features

- Appointment scheduling and management
- Billing and earnings tracking
- Local data storage with ObjectBox
- State management using Bloc
- Modern UI with custom navigation

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) (for iOS)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) for platform builds

### Installation

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd k_app
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Generate ObjectBox model code:**
   ```sh
   flutter pub run build_runner build
   ```

4. **Configure Supabase:**
   - Update your Supabase credentials in [`lib/server/database/supabase.dart`](lib/server/database/supabase.dart).

5. **Run the app:**
   ```sh
   flutter run
   ```

### iOS Setup

- Make sure to run:
  ```sh
  cd ios
  pod install
  cd ..
  ```

### Web

- To run on web:
  ```sh
  flutter run -d chrome
  ```

## Project Structure

- `lib/` - Main Dart source code
- `assets/` - Images and other assets
- `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/` - Platform-specific code

## Useful Commands

- **Build for release:**
  ```sh
  flutter build apk   # Android
  flutter build ios   # iOS
  flutter build web   # Web
  ```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)
