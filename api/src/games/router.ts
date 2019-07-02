import express, { Express } from 'express';
import newGame from './new';

const router = express.Router();

router.post('/new', (req, res, next) => {
    newGame(req).then(() => {
        res.sendStatus(200);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: Express) {
    app.use('/games', router);
}
