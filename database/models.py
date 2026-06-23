from datetime import datetime
from database.db_manager import get_connection


# ── Sessions ──────────────────────────────────────────────────────────────────

def log_session(start_time, duration_seconds, completed):
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


# ── Tasks ─────────────────────────────────────────────────────────────────────

def add_task(title: str) -> int:
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("""
        INSERT INTO tasks (title, created_at, completed)
        VALUES (?, ?, 0)
    """, (title, datetime.utcnow().isoformat()))
    connection.commit()
    new_id = cursor.lastrowid
    connection.close()
    return new_id


def get_all_tasks() -> list[dict]:
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("""
        SELECT id, title, created_at, completed
        FROM tasks
        ORDER BY created_at ASC
    """)
    rows = cursor.fetchall()
    connection.close()
    return [
        {"id": r[0], "title": r[1], "created_at": r[2], "completed": r[3]}
        for r in rows
    ]


def complete_task(task_id: int):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("""
        UPDATE tasks SET completed = 1 WHERE id = ?
    """, (task_id,))
    connection.commit()
    connection.close()


def delete_task(task_id: int):
    connection = get_connection()
    cursor = connection.cursor()
    # Delete steps first — can't leave orphaned steps behind
    cursor.execute("DELETE FROM steps WHERE task_id = ?", (task_id,))
    cursor.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
    connection.commit()
    connection.close()


# ── Steps ─────────────────────────────────────────────────────────────────────

def add_step(task_id: int, title: str, order_index: int) -> int:
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("""
        INSERT INTO steps (task_id, title, order_index, completed)
        VALUES (?, ?, ?, 0)
    """, (task_id, title, order_index))
    connection.commit()
    new_id = cursor.lastrowid
    connection.close()
    return new_id


def get_steps_for_task(task_id: int) -> list[dict]:
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("""
        SELECT id, task_id, title, order_index, completed
        FROM steps
        WHERE task_id = ?
        ORDER BY order_index ASC
    """, (task_id,))
    rows = cursor.fetchall()
    connection.close()
    return [
        {"id": r[0], "task_id": r[1], "title": r[2], "order_index": r[3], "completed": r[4]}
        for r in rows
    ]


def complete_step(step_id: int):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("""
        UPDATE steps SET completed = 1 WHERE id = ?
    """, (step_id,))
    connection.commit()
    connection.close()


def delete_step(step_id: int):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("DELETE FROM steps WHERE id = ?", (step_id,))
    connection.commit()
    connection.close()