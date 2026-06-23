# screens/timer_screen.py
"""
Manages the Focus Timer feature.

Owns the IDLE -> RUNNING -> PAUSED -> COMPLETED state machine and the
countdown mechanism. This file is logic only -- it knows nothing about
colors, fonts, or widget positions. 
"""

from enum import Enum

from kivy.clock import Clock
from kivy.properties import StringProperty, NumericProperty
from kivymd.uix.screen import MDScreen
from datetime import datetime
from database.models import log_session


class TimerState(Enum):
    """The four legal states of a focus session."""
    IDLE = "idle"
    RUNNING = "running"
    PAUSED = "paused"
    COMPLETED = "completed"


# Default session length, in seconds. 25 minutes (classic Pomodoro length).
DEFAULT_DURATION_SECONDS = 25 * 60


class TimerScreen(MDScreen):
    """
    Manages the Focus Timer feature.
    Handles the countdown state machine and (eventually) session logging.
    """

    # Kivy properties -- these exist so that the future .kv layout can
    # bind directly to them (e.g. a label showing `remaining_seconds`,
    # or button text driven by `state`). They are NOT UI elements
    # themselves, just plain data that UI can observe.
    state = StringProperty(TimerState.IDLE.value)
    remaining_seconds = NumericProperty(DEFAULT_DURATION_SECONDS)
    total_seconds = NumericProperty(DEFAULT_DURATION_SECONDS)
    time_display = StringProperty("25:00")
    status_text = StringProperty("Ready")

    def __init__(self, **kwargs):
        
        super().__init__(**kwargs)
        # Handle to the scheduled Clock event, so we can cancel it on
        # pause/reset instead of letting multiple tickers stack up.
        self._clock_event = None


    def on_remaining_seconds(self, instance, value):
        """
        Called automatically by Kivy whenever remaining_seconds changes.
        Converts the raw second count to a MM:SS string for the UI to display.
        """
        minutes = int(value) // 60
        seconds = int(value) % 60
        self.time_display = f"{minutes:02d}:{seconds:02d}"


    def on_state(self, instance, value):
        """
        Called automatically by Kivy whenever state changes.
        Converts the state string to a human-readable status label.
        """
        labels = {
            "idle": "Ready",
            "running": "Focus!",
            "paused": "Paused",
            "completed": "Done!",
        }
        self.status_text = labels.get(value, "")    

        

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _set_state(self, new_state: TimerState):
        """
        Single point of truth for changing state.
        Keeps the internal TimerState enum and the Kivy StringProperty
        in sync, since .kv binding needs a plain string/value, not an
        Enum instance.
        """
        self.state = new_state.value

    def _get_state(self) -> TimerState:
        """Reads the current state back out as a TimerState enum member."""
        return TimerState(self.state)

    def _require_state(self, expected: TimerState):
        """
        Guards a method so it can only run from the state it's meant to
        run from. Raises loudly instead of failing silently, so a bug
        (e.g. a stray button calling pause() while IDLE) surfaces
        immediately during development rather than causing confusing
        downstream behaviour.
        """
        current = self._get_state()
        if current != expected:
            raise ValueError(
                f"Illegal call: expected state {expected.value!r}, "
                f"but current state is {current.value!r}"
            )

    # ------------------------------------------------------------------
    # State transitions (public API -- these are what buttons will call)
    # ------------------------------------------------------------------

    def start(self):
        """IDLE -> RUNNING. Begins a fresh countdown from total_seconds."""
        self._require_state(TimerState.IDLE)
        self._start_time = datetime.utcnow().isoformat()
        self.remaining_seconds = self.total_seconds
        self._set_state(TimerState.RUNNING)
        self._start_ticking()

    def pause(self):
        """RUNNING -> PAUSED. Freezes the countdown without losing progress."""
        self._require_state(TimerState.RUNNING)
        self._stop_ticking()
        self._set_state(TimerState.PAUSED)

    def resume(self):
        """PAUSED -> RUNNING. Continues the countdown from where it left off."""
        self._require_state(TimerState.PAUSED)
        self._set_state(TimerState.RUNNING)
        self._start_ticking()

    def reset(self):
        """PAUSED -> IDLE (or COMPLETED -> IDLE). Discards progress, returns to start."""
        current = self._get_state()
        if current not in (TimerState.PAUSED, TimerState.COMPLETED):
            raise ValueError(
                f"Illegal call: reset() only valid from 'paused' or "
                f"'completed', but current state is {current.value!r}"
            )
        self._stop_ticking()
        self.remaining_seconds = self.total_seconds
        self._set_state(TimerState.IDLE)


    def set_duration(self, minutes: int):
        self._require_state(TimerState.IDLE)
        self.total_seconds = minutes * 60
        self.remaining_seconds = self.total_seconds    

    
    # ------------------------------------------------------------------
    # Countdown mechanism
    # ------------------------------------------------------------------

    def _start_ticking(self):
        """Schedules the per-second countdown callback."""
        # Defensive: cancel any existing event first so we never end up
        # with two tickers running against the same countdown.
        self._stop_ticking()
        self._clock_event = Clock.schedule_interval(self._on_tick, 1)

    def _stop_ticking(self):
        """Cancels the countdown callback, if one is scheduled."""
        if self._clock_event is not None:
            self._clock_event.cancel()
            self._clock_event = None

    def _on_tick(self, dt):
        """
        Called once per second by Kivy's Clock while RUNNING.
        Deliberately dumb: decrement, then check for completion.
        All the "what does completion mean" logic lives in _complete().
        """
        self.remaining_seconds -= 1

        if self.remaining_seconds <= 0:
            self.remaining_seconds = 0
            self._complete()

    def _complete(self):
        self._stop_ticking()
        self._set_state(TimerState.COMPLETED)
        log_session(self._start_time, self.total_seconds, completed=1)