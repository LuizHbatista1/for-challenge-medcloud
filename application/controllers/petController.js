const express = require('express');
const router = express.Router();
const db = require('../database/db');


router.post('/pets', async (req, res) => {
  const { nome, especie, idade } = req.body;

  if (!nome || !especie || idade === undefined) {
    return res.status(400).json({ error: 'Nome, espécie e idade são obrigatórios.' });
  }

  try {
    const [result] = await db.execute(
      'INSERT INTO pets (nome, especie, idade) VALUES (?, ?, ?)',
      [nome, especie, idade]
    );

    
    const novoPet = {
      id: result.insertId,
      nome,
      especie,
      idade
    };

    res.status(201).json(novoPet);
  } catch (error) {
    console.error('Erro ao salvar pet:', error);
    res.status(500).json({ error: 'Erro ao salvar pet no banco de dados.' });
  }
});

module.exports = router;