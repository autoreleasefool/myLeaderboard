import express, { Express } from 'express';
import listPlayers from './list';
import newPlayer from './new';

const router = express.Router();

router.post('/new', (req, res, next) => {
    newPlayer(req).then(() => {
        res.sendStatus(200);
    }).catch(error => {
        next(error);
    });
});

router.get('/list', (_, res, next) => {
    listPlayers().then(players => {
        res.json(players);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: Express) {
    app.use('/players', router);
}
