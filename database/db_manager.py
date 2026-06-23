# database/db_manager.py
"""
Manages the SQLite connection and table initialisation.
This module owns *how* we connect to the database.
It knows nothing about what a "session" is — that's models.py's job.
"""

import os
import sqlite3

DB_PATH = os.path.join("data", "microstep.db")


def get_connection():
    """
    Opens and returns a new connection to the SQLite database.
    Ensures the containing folder exists first, so a fresh clone
    of the project doesn't crash on a missing 'data/' directory.
    """
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    return sqlite3.connect(DB_PATH)


def initialise_db():
    """
    Creates the 'sessions' table if it doesn't already exist.
    Safe to call every time the app starts.
    """
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            start_time TEXT NOT NULL,
            duration_seconds INTEGER NOT NULL,
            completed INTEGER NOT NULL
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            created_at TEXT NOT NULL,
            completed INTEGER NOT NULL DEFAULT 0
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS steps (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            order_index INTEGER NOT NULL DEFAULT 0,
            completed INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (task_id) REFERENCES tasks(id)
        )
    """)

    connection.commit()
    connection.close()