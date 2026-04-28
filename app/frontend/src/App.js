import React, { useState, useEffect } from "react";

const API = process.env.REACT_APP_API_URL || "/api";

export default function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState("");

  const fetchTasks = () =>
    fetch(`${API}/tasks`).then(r => r.json()).then(setTasks);

  useEffect(() => { fetchTasks(); }, []);

  const addTask = async () => {
    if (!title.trim()) return;
    await fetch(`${API}/tasks`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ title }),
    });
    setTitle("");
    fetchTasks();
  };

  const toggleTask = async (task) => {
    await fetch(`${API}/tasks/${task.id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ done: !task.done }),
    });
    fetchTasks();
  };

  const deleteTask = async (id) => {
    await fetch(`${API}/tasks/${id}`, { method: "DELETE" });
    fetchTasks();
  };

  return (
    <div style={{ maxWidth: 600, margin: "40px auto", fontFamily: "sans-serif", padding: "0 20px" }}>
      <h1 style={{ color: "#333" }}>TaskApp</h1>
      <div style={{ display: "flex", gap: 8, marginBottom: 24 }}>
        <input
          value={title}
          onChange={e => setTitle(e.target.value)}
          onKeyDown={e => e.key === "Enter" && addTask()}
          placeholder="Add a task..."
          style={{ flex: 1, padding: "8px 12px", fontSize: 16, borderRadius: 6, border: "1px solid #ddd" }}
        />
        <button
          onClick={addTask}
          style={{ padding: "8px 16px", background: "#4CAF50", color: "#fff", border: "none", borderRadius: 6, cursor: "pointer", fontSize: 16 }}
        >Add</button>
      </div>
      {tasks.map(task => (
        <div key={task.id} style={{ display: "flex", alignItems: "center", gap: 8, padding: "10px 0", borderBottom: "1px solid #eee" }}>
          <input type="checkbox" checked={task.done} onChange={() => toggleTask(task)} style={{ width: 18, height: 18 }} />
          <span style={{ flex: 1, textDecoration: task.done ? "line-through" : "none", color: task.done ? "#999" : "#333", fontSize: 16 }}>
            {task.title}
          </span>
          <button onClick={() => deleteTask(task.id)} style={{ background: "none", border: "none", color: "#e53e3e", cursor: "pointer", fontSize: 18 }}>✕</button>
        </div>
      ))}
      {tasks.length === 0 && <p style={{ color: "#999", textAlign: "center" }}>No tasks yet. Add one above!</p>}
    </div>
  );
}
