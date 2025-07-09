const express = require('express');
const port = process.env.PORT || 80;

const petController = require('./controllers/petController');

const app = express();


app.use(express.json());


app.get('/api/health', (req, res) => {
  res.status(200).send('OK');
});


app.use('/api', petController);


app.listen(port, '0.0.0.0', () => {
  console.log(`Express server running on port ${port}`);
});

