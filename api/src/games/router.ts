import express from 'express';

const router = express.Router();

router.get('/new', (req, res) => {

});

export default function applyRouter(app: express.Express) {
    app.use('/games', router);
}
