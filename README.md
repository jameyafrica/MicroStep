# 🧠 MicroStep

> **Low-friction productivity and task scaffolding built specifically for the ADHD brain.**

🎥 **Demo Video:** [Watch the full 5–10 minute MicroStep walkthrough on YouTube here](#) 

## 🎯 The Problem
Standard productivity tools are built for neurotypical brains. They often exacerbate executive dysfunction through visual clutter, rigid structures, and delayed gratification, leading to task paralysis and overwhelm.

## 💡 The Solution: MicroStep
MicroStep is a mobile application designed to accommodate executive dysfunction rather than punish it. It relies on the pedagogical concept of **scaffolding**—breaking overwhelming projects down into highly achievable micro-steps—paired with immediate visual feedback to simulate dopamine hits and build momentum.

## ✨ Core Features
* **Scaffolded Task Manager:** Input a primary objective and immediately break it down into micro-tasks. Checking off tasks provides instant, satisfying visual feedback.
* **Low-Friction Focus Timer:** A minimalist, highly visible countdown clock that requires a maximum of two taps to start, drastically reducing the barrier to entry for a focus session.
* **Energy & Focus Logging:** A lightweight daily check-in mechanism to record perceived focus levels, allowing users to track their energy trends over time without heavy data entry.

## 🛠️ Tech Stack & Architecture
MicroStep is built entirely in Python, prioritizing clean architecture and a clear separation of concerns:
* **Language:** Python 3.x
* **Frontend UI:** Kivy & KivyMD (Utilizing `.kv` language files to keep UI design strictly decoupled from application logic)
* **Local Database:** SQLite3 (For low-latency, on-device data persistence of tasks and logs)
* **Architecture:** Model-View-Controller (MVC) principles applied to separate database handling, UI layouts, and state management.

## 🚀 How to Run Locally

1. **Clone the repository:**
```bash
   git clone [https://github.com/yourusername/MicroStep.git](https://github.com/yourusername/MicroStep.git)
   cd MicroStep
   ```

2. **Create and activate a virtual environment:**
```bash
   # Windows
   python -m venv venv
   venv\Scripts\activate

   # macOS/Linux
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies:**
```bash
   pip install kivy kivymd
   ```

4. **Run the application:**
```bash
   python main.py
   ```

## 🎓 About This Project
This project was developed as a solo submission for the Semester 4 **Mobile Development** elective track selection (Cohort 2025). All commits represent individual development.

The goal was to demonstrate proficiency in mobile UI state management, local database integration, and cross-platform Python development while building a tool that solves a genuine, real-world accessibility problem.