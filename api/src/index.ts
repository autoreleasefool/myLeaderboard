import './env';

import express, { NextFunction, Request, Response } from 'express';
import Games from './db/games';
import Players from './db/players';
import Plays from './db/plays';
import Octo from './lib/Octo';

Octo.setBranch('ios');
Octo.setUseLocal(true);
Games.getInstance().refreshData();
Players.getInstance().refreshData();
Plays.getInstance().refreshData();

// tslint:disable:no-console

// Print out startup time to default logs
console.log('--------------------');
console.log('Starting new instance of server.');
console.log(new Date());
console.log('--------------------');

// Print out startup time to error
console.error('--------------------');
console.error('Starting new instance of server.');
console.error(new Date());
console.error('--------------------');

// tslint:enable:no-console

const githubToken = process.env.GITHUB_TOKEN;
if (githubToken != null && githubToken.length > 0) {
    Octo.setToken(githubToken);
}

const app = express();
const port = (process.env.NODE_ENV === 'production') ? 80 : 3001;

app.use(express.json());

// Log each request made to the server
app.use((req, _, next) => {
    // tslint:disable:no-console
    console.log(`${new Date().toISOString()}: ${req.method} from ${req.ip} -- ${req.originalUrl}`);
    next();
    // tslint:enable:no-console
  });

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
import applyPlaysRouter from './plays/router';

app.use(express.static('./static'));
app.use(tokenExtraction);
applyGamesRouter(app);
applyPlayersRouter(app);
applyPlaysRouter(app);
app.use(errorHandler);

app.listen(port, () => {
    console.log(`myLeaderboard API listening on port ${port}`);
});
