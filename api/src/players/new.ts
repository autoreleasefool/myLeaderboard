import { Request } from 'express';
import Players from '../db/players';
import { Player } from '../lib/types';

export default async function add(req: Request): Promise<Player> {
    const playerName: string = req.body.name;
    const playerUsername: string = req.body.username;
    const board: number = req.body.board;

    return addPlayer(playerName, playerUsername, board);
}

export async function addPlayer(playerName: string, playerUsername: string, board: number): Promise<Player> {
    // Input validation
    if (playerName == null || playerName.length === 0) {
        throw new Error('Missing "name".');
    } else if (playerUsername == null || playerUsername.length === 0) {
        throw new Error('Missing "username".');
    } else if (board == null) {
        throw new Error('Missing "board".');
    }

    if (playerUsername.charAt(0) === '@') {
        playerUsername = playerUsername.substr(1);
    }

    const newPlayer = createPlayer(playerName, playerUsername, board);
    Players.getInstance().add(newPlayer, `Adding player "${playerUsername}`);

    return newPlayer;
}

function createPlayer(displayName: string, username: string, board: number): Player {
    if (Players.getInstance().isUsernameTaken(username, board)) {
        throw new Error(`A player with username "${username}" already exists.`);
    }

    return {
        id: Players.getInstance().getNextId(),
        displayName,
        username,
        board,
    };
}
