import express, { Express } from 'express';
import newBoard from './new';

const router = express.Router();

router.post('/new', (req, res, next) => {
    newBoard(req).then(board => {
        res.json(board);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: Express): void {
    app.use('/boards', router);
}
