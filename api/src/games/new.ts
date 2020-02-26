import { Request } from 'express';
import Games from '../db/games';
import { Game } from '../lib/types';

export default async function add(req: Request): Promise<Game> {
    const name = req.body.name;
    const hasScores = req.body.hasScores;

    return addGame(name, hasScores);
}

export async function addGame(name: string, hasScores: boolean): Promise<Game> {
    // Input validation
    if (name == null || name.length === 0) {
        throw new Error('Missing "name".');
    }
    if (hasScores == null || (hasScores !== true && hasScores !== false)) {
        throw new Error('Missing "hasScores" or value is not boolean.');
    }

    const gameList = Games.getInstance().all({});
    const newGame = createGame(name, hasScores, gameList);
    Games.getInstance().add(newGame, `Adding game ${name}`);

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
