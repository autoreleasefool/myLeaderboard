import express, { NextFunction, Request, Response } from 'express';
import Octo from './lib/Octo';

const githubToken = process.env.GITHUB_TOKEN;
if (githubToken != null && githubToken.length > 0) {
    Octo.setToken(githubToken);
}

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
    if (token != null && token.length > 0) {
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
