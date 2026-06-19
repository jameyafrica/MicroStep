# main.py
#boots ap and hands control over to Kivy

from kivy.lang import Builder
from kivymd.app import MDApp
from screens.timer_screen import TimerScreen


class ADHDTrackerApp(MDApp):
    def build(self):
        # Load the KV file so Kivy knows the layout rules for TimerScreen
        Builder.load_file("kv/timer_screen.kv")
        # Return an instance of TimerScreen as the temporary root widget
        return TimerScreen()


if __name__ == "__main__":
    ADHDTrackerApp().run()

# Right now build() returns just the timer screen directly. 
# Once we add navigation in a later commit,
#  this will return a ScreenManager instead. clea