const express = require('express');
const axios = require('axios');

// express server
const app = express();
const PORT = 3000;

app.use(express.json());

// route predict
app.post('/api/moderation/predict', async (req, res) => {
    try {
        const {text, language} = req.body;
        const response = await axios.get('https://moderation.logora.fr/predict', {params: {text, language}});
        res.json(response.data);
    }
	catch (error) {
        console.error(error);
        res.status(500).json({error: 'Erreur'});
    }
});

// route score
app.post('/api/moderation/score', async (req, res) => {
    try {
        const {text, language} = req.body;
        const response = await axios.get('https://moderation.logora.fr/score', {params: {text, language}});
        res.json(response.data);
    }
	catch (error) {
        console.error(error);
        res.status(500).json({error: 'Erreur'});
    }
});

// start
const server = app.listen(PORT, () => {
    console.log('Server listening on port ${PORT}');
});

module.exports = server; // Exporter le serveur pour les tests