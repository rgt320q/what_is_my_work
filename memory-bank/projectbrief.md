# Project Brief: What Is My Work

## 1. Core Concept

"What Is My Work" is a job simulation game designed to run on Flutter, with a primary focus on Web and Android platforms. The game simulates progressing through a profession by completing a series of tasks.

## 2. Gameplay Structure

The game is organized into a clear hierarchy:

- **Specializations (Uzmanlıklar):** The highest-level career paths or fields.
- **Levels (Kademeler):** Each specialization is divided into several levels, representing stages of expertise.
- **Tasks (Görevler):** Each level consists of a series of tasks that represent the duties and responsibilities of that profession at that stage.

## 3. Core Gameplay Loop

1.  **Task Completion:** The player starts a task, which has a specific duration. Once the timer completes, the task is marked as done, and the next task in the sequence becomes available.
2.  **Level Completion:** After all tasks within a level are completed, the player must pass a quiz to advance.

## 4. Quiz and Progression System

The quiz is a critical progression gate:

-   **Quiz Trigger:** A quiz is initiated automatically after the last task of a level is finished.
-   **Success Condition:** If the player answers **all** questions correctly, they pass the level and unlock the next one.
-   **Failure Loop:**
    1.  If any questions are answered incorrectly, the specific tasks corresponding to those questions are reset to an "incomplete" status.
    2.  The player must repeat these incomplete tasks.
    3.  Upon completing them again, the player is re-quizzed, but **only on the questions they previously answered incorrectly**.
    4.  This cycle of re-doing tasks and re-taking a partial quiz continues until all questions for the level have been answered correctly.

## 5. Technical Direction

The project is built with Flutter. Further technical details and patterns are to be determined by analyzing the existing codebase.
