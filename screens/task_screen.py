from kivymd.uix.screen import MDScreen
from database import models


class TaskScreen(MDScreen):
    """
    Controller for the Task Manager screen.
    Handles all task and step logic by delegating to models.py.
    No raw SQL here — ever.
    """

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.tasks = []
        self.selected_task_id = None

    def on_pre_enter(self):
        """
        Kivy lifecycle hook.
        Called automatically every time the user navigates to this screen.
        Ensures the task list is always fresh.
        """
        self.load_tasks()

    def load_tasks(self):
        """
        Fetches all tasks from the database and stores them in self.tasks.
        self.tasks is a list of dicts — each dict has: id, title, created_at, completed.
        """
        self.tasks = models.get_all_tasks()
        print(f"[TaskScreen] Loaded {len(self.tasks)} task(s).")

    def add_task(self, title):
        """
        Adds a new task to the database, then reloads the task list.
        title: str — comes from a text input field (wired up in Commit 13).
        """
        title = title.strip()
        if not title:
            print("[TaskScreen] add_task ignored — empty title.")
            return

        new_id = models.add_task(title)
        print(f"[TaskScreen] Task added with id={new_id}.")
        self.load_tasks()

    def add_step(self, task_id, title, order_index):
        """
        Adds a step to an existing task.
        task_id: int — the parent task's id.
        title: str — the step description.
        order_index: int — position in the step list (0-based).
        """
        title = title.strip()
        if not title:
            print("[TaskScreen] add_step ignored — empty title.")
            return

        new_id = models.add_step(task_id, title, order_index)
        print(f"[TaskScreen] Step added with id={new_id} to task_id={task_id}.")

    def complete_step(self, step_id):
        """
        Marks a single step as completed, then reloads tasks for a fresh state.
        step_id: int — the step to mark done.
        """
        models.complete_step(step_id)
        print(f"[TaskScreen] Step id={step_id} marked complete.")
        self.load_tasks()