import express from 'express';
import addPlayer from './add';

const router = express.Router();

router.get('/new', (req, res) => {
    addPlayer(req, res);
});

export default function applyRouter(app: express.Express) {
    app.use('/players', router);
}
