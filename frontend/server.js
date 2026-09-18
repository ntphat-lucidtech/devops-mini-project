const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const API_URL = process.env.BACKEND_API_URL || 'http://localhost:5000';

app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Day 6 - Docker Compose Fullstack</title>
      <style>
        body { font-family: Arial, sans-serif; background: #0f172a; color: #fff; text-align: center; padding-top: 50px; }
        .card { background: #1e293b; display: inline-block; padding: 30px; border-radius: 12px; border: 1px solid #334155; }
        h1 { color: #38bdf8; }
        .badge { background: #22c55e; color: #000; padding: 5px 12px; border-radius: 15px; font-weight: bold; }
      </style>
    </head>
    <body>
      <div class="card">
        <h1>helooooo hi  </h1>
        <p>Frontend -> Backend (.NET API) -> Database (PostgreSQL)</p>
        <p>Connected Backend API: <code>${API_URL}</code></p>
        <span class="badge">Docker Compose Status: ACTIVE</span>
      </div>
    </body>
    </html>
  `);
});

app.listen(PORT, () => console.log(`Frontend running on port ${PORT}`));
