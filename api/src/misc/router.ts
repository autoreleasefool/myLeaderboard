import express, { Express } from 'express';
import checkForUpdates from './hasUpdates';
import refresh from './refresh';

const router = express.Router();

router.post('/refresh', (_, res, next) => {
    refresh().then(() => {
        res.sendStatus(200);
    }).catch(error => {
        next(error);
    });
});

router.get('/hasUpdates', (req, res, next) => {
    checkForUpdates(req).then(hasUpdates => {
        res.json({ hasUpdates });
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: Express) {
    app.use('/misc', router);
}
