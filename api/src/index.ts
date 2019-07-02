import express, { NextFunction, Request, Response } from 'express';
import Octo from './lib/Octo';

Octo.setBranch('react');

const app = express();
const port = (process.env.NODE_ENV === 'production') ? 80 : 3001;

app.use(express.json());

function errorHandler(err: any, _: Request, res: Response, __: NextFunction) {
    // tslint:disable no-console
    console.log(err);
    res.json(err);
}

function tokenExtraction(req: Request, _: Response, next: NextFunction) {
    const token = req.body.token;
    if (token == null || token.length === 0) {
        next(new Error('Token was not provided.'));
    } else {
        Octo.setToken(req.body.token);
    }

    next();
}

import applyGamesRouter from './games/router';
import applyPlayersRouter from './players/router';
import applyStandingsRouter from './standings/router';

app.use(tokenExtraction);
applyGamesRouter(app);
applyPlayersRouter(app);
applyStandingsRouter(app);
app.use(errorHandler);

app.listen(port, () => {
    console.log(`myLeaderboard API listening on port ${port}`);
});
