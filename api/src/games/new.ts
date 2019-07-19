import { Request } from 'express';
import Octo from '../lib/Octo';
import { Game } from '../lib/types';

export default async function add(req: Request): Promise<Game> {
    const name = req.body.name;
    const hasScores = req.body.hasScores;

    // Input validation
    if (name == null || name.length === 0) {
        throw new Error('Missing "name".');
    }
    if (hasScores == null || (hasScores !== true && hasScores !== false)) {
        throw new Error('Missing "hasScores" or value is not boolean.');
    }

    const filename = `db/games.json`;
    const gameListBlob = await Octo.getInstance().blob(filename);
    const gameList: Array<Game> = JSON.parse(gameListBlob.content);

    const newGame = createGame(name, hasScores, gameList);
    gameList.push(newGame);

    await Octo.getInstance().write([{
        content: JSON.stringify(gameList, undefined, 4),
        message: `Adding game "${name}"`,
        path: filename,
        sha: gameListBlob.sha,
    }]);

    return newGame;
}

function createGame(name: string, hasScores: boolean, existingGames: Array<Game>): Game {
    let maxId = 0;
    for (const existingGame of existingGames) {
        if (existingGame.id > maxId) {
            maxId = existingGame.id;
        }

        if (existingGame.name === name) {
            throw new Error(`A game with name "${name}" already exists.`);
        }
    }

    return {
        hasScores,
        id: maxId + 1,
        name,
    };
}
