import express from 'express';

const router = express.Router();

export default function applyRouter(app: express.Express) {
    app.use('/games', router);
}
