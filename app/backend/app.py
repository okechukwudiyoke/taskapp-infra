from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2
import os
import time

app = Flask(__name__)
CORS(app)

def get_db():
    return psycopg2.connect(
        host=os.environ.get("DB_HOST", "postgres"),
        database=os.environ.get("DB_NAME", "taskapp"),
        user=os.environ.get("DB_USER", "taskapp"),
        password=os.environ.get("DB_PASSWORD", "changeme")
    )

def init_db():
    for i in range(10):
        try:
            conn = get_db()
            cur = conn.cursor()
            cur.execute("""CREATE TABLE IF NOT EXISTS tasks (
                id SERIAL PRIMARY KEY,
                title VARCHAR(255) NOT NULL,
                done BOOLEAN DEFAULT FALSE,
                created_at TIMESTAMP DEFAULT NOW()
            )""")
            conn.commit()
            cur.close()
            conn.close()
            print("DB initialized")
            return
        except Exception as e:
            print(f"DB not ready, retrying... {e}")
            time.sleep(3)

@app.route("/api/health")
def health():
    return jsonify({"status": "ok"})

@app.route("/api/tasks", methods=["GET"])
def get_tasks():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT id, title, done FROM tasks ORDER BY created_at DESC")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify([{"id": r[0], "title": r[1], "done": r[2]} for r in rows])

@app.route("/api/tasks", methods=["POST"])
def create_task():
    data = request.get_json()
    conn = get_db()
    cur = conn.cursor()
    cur.execute("INSERT INTO tasks (title) VALUES (%s) RETURNING id", (data["title"],))
    task_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"id": task_id, "title": data["title"], "done": False}), 201

@app.route("/api/tasks/<int:task_id>", methods=["PUT"])
def update_task(task_id):
    data = request.get_json()
    conn = get_db()
    cur = conn.cursor()
    cur.execute("UPDATE tasks SET done=%s WHERE id=%s", (data["done"], task_id))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"status": "updated"})

@app.route("/api/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    conn = get_db()
    cur = conn.cursor()
    cur.execute("DELETE FROM tasks WHERE id=%s", (task_id,))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"status": "deleted"})

init_db()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
