import { Request } from 'express';
import Players from '../db/players';
import { Player } from '../lib/types';

export default async function add(req: Request): Promise<Player> {
    const playerName: string = req.body.name;
    const playerUsername: string = req.body.username;

    return addPlayer(playerName, playerUsername);
}

export async function addPlayer(playerName: string, playerUsername: string): Promise<Player> {
    // Input validation
    if (playerName == null || playerName.length === 0) {
        throw new Error('Missing "name".');
    } else if (playerUsername == null || playerUsername.length === 0) {
        throw new Error('Missing "username".');
    }

    if (playerUsername.charAt(0) === '@') {
        playerUsername = playerUsername.substr(1);
    }

    const newPlayer = createPlayer(playerName, playerUsername);
    Players.getInstance().add(newPlayer, `Adding player "${playerUsername}`);

    return newPlayer;
}

function createPlayer(displayName: string, username: string): Player {
    if (Players.getInstance().isUsernameTaken(username)) {
        throw new Error(`A player with username "${username}" already exists.`);
    }

    return {
        id: Players.getInstance().getNextId(),
        displayName,
        username,
    };
}
