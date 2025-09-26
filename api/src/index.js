require('dotenv').config();
const express = require('express');
const path = require('path');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const { z } = require('zod');
const { pool } = require('./db');

const app = express();
const PORT = process.env.PORT || 3000;

console.log('Booting API process...');

// middlewares
app.use(helmet());
app.use(cors());
app.use(morgan('tiny'));
app.use(express.json());
app.use('/api', rateLimit({ windowMs: 60_000, max: 300 }));

// routes API
const router = express.Router();

router.get('/health', async (_req, res) => {
    const r = await pool.query('SELECT 1 as ok');
    res.json({ ok: true, db: r.rows[0].ok === 1 });
});

const createTodoSchema = z.object({ title: z.string().min(1) });
router.get('/cards', async (_req, res) => {
    const r = await pool.query('SELECT * FROM cards ORDER BY id ASC');
    res.json(r.rows);
});
router.post('/todos', async (req, res) => {
    const { title } = createTodoSchema.parse(req.body);
    const r = await pool.query('INSERT INTO todos (title) VALUES ($1) RETURNING *', [title]);
    res.status(201).json(r.rows[0]);
});

app.use('/api/v1', router);

// statics (front build Vite)
const publicDir = path.join(__dirname, '..', 'public');
app.use(express.static(publicDir));
app.get('*', (_req, res) => res.sendFile(path.join(publicDir, 'index.html')));

// démarrage serveur
app.listen(PORT, () => {
    console.log(`API+Web sur :${PORT}`);
});
