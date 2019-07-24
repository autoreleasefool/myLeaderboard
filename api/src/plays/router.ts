import express from 'express';
import record from './record';

const router = express.Router();

router.post('/record', (req, res, next) => {
    record(req).then(play => {
        res.json(play);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: express.Express) {
    app.use('/plays', router);
}
