# main.py
from kivy.lang import Builder
from kivymd.app import MDApp
from screens.timer_screen import TimerScreen
from database.db_manager import initialise_db


class ADHDTrackerApp(MDApp):
    def build(self):
        # Load the KV file so Kivy knows the layout rules for TimerScreen
        Builder.load_file("kv/timer_screen.kv")
        # Return an instance of TimerScreen as the temporary root widget
        return TimerScreen()

    def on_start(self):
        # Ensure the 'sessions' table exists before the app becomes interactive.
        # Safe to call every launch — CREATE TABLE IF NOT EXISTS is idempotent.
        initialise_db()


if __name__ == "__main__":
    ADHDTrackerApp().run()
