import './env';

import express, { NextFunction, Request, Response } from 'express';
import fs from 'fs';
import https from 'https';
import Octo from './common/Octo';
import Games from './db/games';
import Players from './db/players';
import Plays from './db/plays';

Games.getInstance().refreshData();
Players.getInstance().refreshData();
Plays.getInstance().refreshData();

let sslOptions: {
    ca?: Buffer;
    cert?: Buffer;
    key?: Buffer;
} = {}

if (process.env.PRODUCTION) {
    sslOptions = {
        ca: fs.readFileSync('ssl/intermediate.crt'),
        cert: fs.readFileSync('ssl/primary.crt'),
        key: fs.readFileSync('ssl/private.key'),
    }
}

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

app.use((_, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
});

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
import applyMiscRouter from './misc/router';
import applyPlayersRouter from './players/router';
import applyPlaysRouter from './plays/router';

app.use(express.static('./static'));
app.use(tokenExtraction);
applyGamesRouter(app);
applyPlayersRouter(app);
applyPlaysRouter(app);
applyMiscRouter(app);
app.use(errorHandler);

if (process.env.PRODUCTION) {
    https.createServer(sslOptions, app).listen(443);
} else {
    app.listen(port, () => {
        console.log(`myLeaderboard API listening on port ${port}`);
    });
}
