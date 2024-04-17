// server.js
const express = require('express');
const app = express();
const cassandra = require('cassandra-driver');

const client = new cassandra.Client({ 
    contactPoints: ['localhost'], 
    localDataCenter: 'datacenter1', 
    keyspace: 'flashcards' 
});

app.get('/flashcards', async (req, res) => {
    const result = await client.execute('SELECT * FROM flashcards');
    res.json(result.rows);
});

app.listen(3001, () => console.log('Server listening on port 3001'));