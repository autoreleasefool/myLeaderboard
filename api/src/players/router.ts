import express, { Express } from 'express';
import listPlayers from './list';
import newPlayer from './new';

const router = express.Router();

router.post('/new', (req, res, next) => {
    newPlayer(req).then(player => {
        res.json(player);
    }).catch(error => {
        next(error);
    });
});

router.get('/list', (req, res, next) => {
    listPlayers(req).then(players => {
        res.json(players);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: Express) {
    app.use('/players', router);
}
