import express from 'express';
import record from './record';
import listPlays from './list';

const router = express.Router();

router.post('/record', (req, res, next) => {
    record(req).then(play => {
        res.json(play);
    }).catch(error => {
        next(error);
    });
});

router.get('/list/:boardId', (req, res, next) => {
    listPlays(req).then(plays => {
        res.json(plays);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: express.Express): void {
    app.use('/plays', router);
}
