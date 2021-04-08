import express, { Express } from 'express';
import listGames from './list';
import newGame from './new';
import gameStandings from './standings';

const router = express.Router();

router.post('/new', (req, res, next) => {
    newGame(req).then(game => {
        res.json(game);
    }).catch(error => {
        next(error);
    });
});

router.get('/list', (req, res, next) => {
    listGames(req).then(games => {
        res.json(games);
    }).catch(error => {
        next(error);
    });
});

router.get('/standings/:boardId/:id', (req, res, next) => {
    gameStandings(req).then(standings => {
        res.json(standings);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: Express): void {
    app.use('/games', router);
}
