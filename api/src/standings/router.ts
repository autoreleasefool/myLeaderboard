import express from 'express';

const router = express.Router();

router.get('/record', (req, res) => {

});

export default function applyRouter(app: express.Express) {
    app.use('/standings', router);
}
