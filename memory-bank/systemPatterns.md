# System Patterns

## 1. Architecture

The application follows a hybrid architecture combining the **BLoC pattern** for state management with the **Flame game engine** for the core game loop and UI rendering.

- **Data Layer:** The game's content (Levels, Stages, Tasks, Quizzes) is defined in hardcoded lists in `lib/game/levels.dart` and `lib/game/quizzes.dart`. The data models are defined in `lib/game/models.dart`.
- **Business Logic Layer:** The `GameBloc` (`lib/game/bloc/game_bloc.dart`) acts as the central business logic component. It responds to events and manages the overall game state (`GameLoaded`, etc.).
- **Presentation Layer:** This is handled by two distinct parts:
    1.  **Flame Engine (`game.dart`):** The `WhatIsMyWorkGame` class manages the intricate game state (current task, timers, quiz progression) and controls which UI overlay is currently visible.
    2.  **Flutter Widgets (`game.dart`, `quiz_overlay.dart`, `settings_screen.dart`):** The actual UI is composed of standard Flutter widgets. These widgets are displayed as overlays on top of the Flame game canvas. They read state from the `GameBloc` and the `WhatIsMyWorkGame` instance and send events back to them.

## 2. State Management

- **Global State:** Managed by `GameBloc`. This holds the top-level game data (`List<Level>`) that can be modified by the settings screen.
- **Game Loop State:** Managed within the `WhatIsMyWorkGame` class (`game.dart`). This includes the player's current position (`currentLevel`, `currentStage`, `currentTask`), active timers, and the state of the current quiz (`failedQuestionsQuiz`, `userAnswers`).
- **UI State:** Managed implicitly by the `overlayBuilderMap` in `main.dart`. The `WhatIsMyWorkGame` class controls which overlay is active by adding or removing strings from the `game.overlays` list.

## 3. Key Component Relationships

- `main.dart` initializes the `GameBloc` and the `GameWidget`, linking them together.
- `GameWidget` creates the `WhatIsMyWorkGame` instance.
- `WhatIsMyWorkGame` receives the level data from the `GameBloc` state.
- UI Overlays (like `GameStatusOverlay`) are built with a reference to the `WhatIsMyWorkGame` instance, allowing them to read game loop state directly and call methods on the game object (e.g., `game.startTask()`).
- The `SettingsScreen` reads from and writes to the `GameBloc` to allow for dynamic modification of game data.

## 4. Game Progression Logic

The core progression is a state machine managed within `WhatIsMyWorkGame`:

1.  **Idle State:** The `GameStatus` overlay is shown. The player can see the task list.
2.  **Task Active:** A timer is running (`TaskTimer` overlay).
3.  **Task Complete:** The task is marked `isCompleted=true`. The game advances to the next task or, if the stage is complete, triggers a quiz.
4.  **Quiz Active:** The `Quiz` overlay is shown.
5.  **Quiz Finished:** The `QuizResult` overlay is shown.
    -   **On Success:** The game advances to the next stage/level.
    -   **On Failure:** The relevant tasks are marked `isCompleted=false`, and the game state transitions back to the Idle State, waiting for the user to complete the failed tasks again.
