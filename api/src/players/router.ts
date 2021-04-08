import express, { Express } from 'express';
import listPlayers from './list';
import newPlayer from './new';
import playerRecord from './record';

const router = express.Router();

router.post('/new', (req, res, next) => {
    newPlayer(req).then(player => {
        res.json(player);
    }).catch(error => {
        next(error);
    });
});

router.get('/list/:boardId', (req, res, next) => {
    listPlayers(req).then(players => {
        res.json(players);
    }).catch(error => {
        next(error);
    });
});

router.get('/record/:playerId/:gameId', (req, res, next) => {
    playerRecord(req).then(record => {
        res.json(record);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: Express): void {
    app.use('/players', router);
}
