# database/models.py
"""
Data access layer.
All SQL queries are defined here — screens never write raw SQL.
"""

from database.db_manager import get_connection


def log_session(start_time, duration_seconds, completed):
    """
    Inserts a new row into the 'sessions' table.

    Args:
        start_time (str): ISO 8601 datetime string, e.g. "2026-06-19T14:30:00"
        duration_seconds (int): planned duration of the session
        completed (int): 1 if the session finished naturally, 0 if interrupted

    Returns:
        int: the id of the newly inserted row
    """
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        INSERT INTO sessions (start_time, duration_seconds, completed)
        VALUES (?, ?, ?)
    """, (start_time, duration_seconds, completed))

    connection.commit()
    new_id = cursor.lastrowid
    connection.close()

    return new_id