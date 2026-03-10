# ArvyaX Mini

An immersive and minimal ambient sound companion built with Flutter, Riverpod, and Hive.

## How to run the project
1. Ensure you have Flutter SDK installed (`>=3.4.0` recommended).
2. Clone/unzip the project.
3. Run `flutter pub get`.
4. Run the app: `flutter run` on iOS, Android, macOS, or Web.
5. Alternatively, install the provided `app-release.apk` on an Android device.

## Architecture Explanation

This app uses a Feature-First, Layered Clean Architecture pattern.
### Folder Structure
- `lib/data/`: Houses data models, DTOs, and Repositories (Ambience, Reflection, Session).
- `lib/features/`: Contains feature-specific logic. Each feature (ambience, player, journal) has its own `screens`, `providers`, and `widgets`.
- `lib/shared/`: Global resources like Theme design tokens, shared widgets (chips, buttons), and navigation Router.
- `assets/`: Contains audio files and the JSON list of available ambiences.

### State Management & Data Flow
**Riverpod** is used for state management. 
- **Repositories** connect to offline data sources (Hive / Local Assets) and expose future/synchronous methods.
- **Providers / Notifiers** consume repositories. For example, `ambiencesProvider` reads the JSON list, `sessionProvider` manages the active playback and countdown timers, and `filteredAmbiencesProvider` computes search outputs.
- **UI** uses `ref.watch()` to listen and react predictably, preserving unidirectional data flow.

## Packages Used
- **flutter_riverpod**: For dependency injection, predictable state propagation, and boilerplate reduction compared to Bloc/Provider.
- **go_router**: For declarative path-based routing and deep-linking support, easily accommodating the `/details`, `/player`, and `/journal` flows.
- **hive & hive_flutter**: A lightweight, blazing-fast local NoSQL database perfect for synchronous saves and loads of Reflections and Session States.
- **just_audio**: Highly robust audio package with support for precise looping, streaming, and background capabilities.
- **intl**: For clean and localized Date and Time formatting within the Journal History screen.
- **uuid**: Used to uniquely identify each Journal reflection.

## Tradeoffs & Future Improvements
If given two more days, I would prioritize:
1. **Background Audio & State Restoration**: Currently, the timer operates while the app is active and audio stops correctly. However, a full AudioService integration (`audio_service` package) would allow playback and lock-screen controls even when the app is killed or fully suspended in the background. (I integrated Hive state caching for the MiniPlayer active state, but OS-level media integration needs `audio_service`).
2. **Smooth Page Transitions**: Adding custom fade/slide transitions in `go_router` for a more "immersive" and fluid, Apple-like feel when opening the player.
3. **Advanced Animations**: Complex shaders or Lottie for the breathing animation loop rather than a generic RadialGradient. 
4. **Unit and Widget Tests**: Injecting mock repositories into Riverpod to validate business rules and audio timer accuracy.
