import './env';

import express, { NextFunction, Request, Response } from 'express';
import Octo from './common/Octo';

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

const githubToken = process.env.GITHUB_TOKEN;
if (githubToken != null && githubToken.length > 0) {
    Octo.setToken(githubToken);
}

const app = express();
const port = 3001;

app.use((_, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
});

app.use(express.json());

// Log each request made to the server
app.use((req, _, next) => {
    console.log(`${new Date().toISOString()}: ${req.method} from ${req.ip} -- ${req.originalUrl}`);
    next();
});

function errorHandler(err: any, req: Request, res: Response): void {
    console.log(err, req);
    res.json(err);
}

function tokenExtraction(req: Request, _: Response, next: NextFunction): void {
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

// SSL

import fs from 'fs';
import https from 'https';
import { apiURL } from './common/utils';

if (process.env.SSL_ENABLED) {
    const privateKey = fs.readFileSync(`/etc/letsencrypt/live/${apiURL(false)}/privkey.pem`, 'utf8');
    const certificate = fs.readFileSync(`/etc/letsencrypt/live/${apiURL(false)}/cert.pem`, 'utf8');
    const ca = fs.readFileSync(`/etc/letsencrypt/live/${apiURL(false)}/chain.pem`, 'utf8');

    const credentials = {
        ca,
        cert: certificate,
        key: privateKey,
    };

    const httpsServer = https.createServer(credentials, app);
    httpsServer.listen(443, () => {
        console.log('myLeaderboard API listening on port 443.');
    });
} else {
    app.listen(port, () => {
        console.log(`myLeaderboard API listening on port ${port}`);
    });
}

import Games from './db/games';
import Players from './db/players';
import Plays from './db/plays';

Games.getInstance().refreshData();
Players.getInstance().refreshData();
Plays.getInstance().refreshData();
