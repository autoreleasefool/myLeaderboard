import express from 'express';

const app = express();
const port = (process.env.NODE_ENV === 'production') ? 80 : 3000;

import applyGamesRouter from './games/router';
import applyPlayersRouter from './players/router';
import applyStandingsRouter from './standings/router';

applyGamesRouter(app);
applyPlayersRouter(app);
applyStandingsRouter(app);

app.listen(port, () => {
    console.log(`myLeaderboard API listening on port ${port}`);
});
