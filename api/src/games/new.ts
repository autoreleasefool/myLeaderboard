import { Request } from 'express';
import Games from '../db/games';
import { Game } from '../lib/types';

export default async function add(req: Request): Promise<Game> {
    const name: string = req.body.name;
    const hasScores: boolean = req.body.hasScores;

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

    const newGame = createGame(name, hasScores);
    Games.getInstance().add(newGame, `Adding game ${name}`);

    return newGame;
}

function createGame(name: string, hasScores: boolean): Game {
    if (Games.getInstance().isNameTaken(name)) {
        throw new Error(`A game with the name "${name}" already exists.`);
    }

    return {
        hasScores,
        id: Games.getInstance().getNextId(),
        name,
    };
}
