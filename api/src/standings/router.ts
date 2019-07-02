import express from 'express';
import record from './record';

const router = express.Router();

router.post('/record', (req, res, next) => {
    record(req).then(() => {
        res.sendStatus(200);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: express.Express) {
    app.use('/standings', router);
}
