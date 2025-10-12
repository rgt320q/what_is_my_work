# Tech Context

## 1. Core Technologies

- **Framework:** Flutter
- **Language:** Dart

## 2. Key Libraries & Dependencies

- **State Management:** `flutter_bloc` (BLoC pattern). This is used to manage the global game state, such as the loaded levels and settings.
- **Game Engine:** `flame`. The core game loop, rendering, and overlay management are built on the Flame engine.
- **Web Interaction:** `url_launcher`. Used to open external URLs in the browser for tasks and help links.

## 3. Development Setup

- The project is a standard Flutter project and can be run on any platform Flutter supports (Web and Android are primary targets).
- The entry point of the application is `lib/main.dart`.
- All game content (levels, tasks, quizzes) is currently hardcoded in `lib/game/levels.dart` and `lib/game/quizzes.dart`.

## 4. Tool Usage Patterns

- **State Events:** The UI and game engine dispatch events (e.g., `GameStarted`, `UpdateSettings`) to the `GameBloc`.
- **State Updates:** The UI rebuilds based on states emitted by the `GameBloc` (e.g., `GameLoaded`).
- **Game Overlays:** The UI is rendered using Flame's overlay system. Different widgets are mapped to string keys (e.g., 'GameStatus', 'Quiz') and are shown/hidden by the main game logic in `WhatIsMyWorkGame`.
