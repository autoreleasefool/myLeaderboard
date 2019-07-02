import express, { Express } from 'express';
import newPlayer from './new';

const router = express.Router();

router.post('/new', (req, res, next) => {
    const playerName = req.body.name;
    const playerUsername = req.body.username;
    if (playerName == null || playerName.length === 0) {
        next(new Error('Missing "name".'));
    } else if (playerUsername == null || playerUsername.length === 0) {
        next(new Error('Missing "username".'));
    }

    newPlayer(playerName, playerUsername).then(() => {
        res.sendStatus(200);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: Express) {
    app.use('/players', router);
}
