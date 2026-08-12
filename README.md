# 🧠 MicroStep — Core Task Scaffolding Engine

> **Low-friction productivity and task scaffolding built specifically for the ADHD brain.**

🎥 **Demo Video:** [Watch the MicroStep Foundational Track walkthrough on YouTube](#)

## 🎯 The Problem
Standard productivity tools are built for neurotypical brains. They exacerbate executive dysfunction through visual clutter, rigid structures, and heavy backlogs, leading to task paralysis and decision fatigue.

## 💡 The Solution: MicroStep
MicroStep is a cross-platform mobile application designed to accommodate executive dysfunction rather than punish it. It relies on the pedagogical concept of **scaffolding**—breaking overwhelming projects down into atomic micro-steps—paired with backlog shielding and immediate visual feedback to lower task activation energy.

## ✨ Core Features (Track 1 Scope)
* **Scaffolded Task Manager:** Input a primary objective and immediately break it down into micro-steps to focus exclusively on the immediate next action.
* **Backlog Shielding:** Isolates active micro-steps on the primary view, shielding users from seeing heavy task queues.
* **Low-Friction Focus Timer:** A minimalist countdown timer requiring minimal taps to launch focus sessions directly tied to active micro-steps.
* **Offline-First Storage:** Fast, local data persistence ensuring total privacy and instant access without internet dependencies.

## 🛠️ Tech Stack & Architecture
* **Language:** Dart
* **Framework:** Flutter
* **Local Persistence:** `sqflite` / `shared_preferences`
* **Architecture:** Modular Widget Architecture with state management separating UI components, local data services, and business logic.

## 🚀 How to Run Locally

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/yourusername/microstep-flutter-core.git](https://github.com/yourusername/microstep-flutter-core.git)
   cd microstep-flutter-core


Install Flutter dependencies:

Bash
flutter pub get
Run the application:

Bash
flutter run

🎓 About This Project
This project was developed as part of the submission criteria for the Mobile Development elective track selection at WeThinkCode (Cohort 2025).

It fulfills Track 1 (Introductory Flutter & Dart Track) requirements, demonstrating core proficiency in Dart syntax, custom widget design, local state management, and offline database persistence.