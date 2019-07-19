import { Request } from 'express';
import Octo from '../lib/Octo';
import { Player } from '../lib/types';

export default async function add(req: Request): Promise<Player> {
    const playerName: string = req.body.name;
    let playerUsername: string = req.body.username;

    // Input validation
    if (playerName == null || playerName.length === 0) {
        throw new Error('Missing "name".');
    } else if (playerUsername == null || playerUsername.length === 0) {
        throw new Error('Missing "username".');
    }

    if (playerUsername.charAt(0) === '@') {
        playerUsername = playerUsername.substr(1);
    }

    const filename = `data/players.json`;
    const playerListBlob = await Octo.getInstance().blob(filename);
    const playerList: Array<Player> = JSON.parse(playerListBlob.content);

    const newPlayer = createPlayer(playerName, playerUsername, playerList);
    playerList.push(newPlayer);

    await Octo.getInstance().write([{
        content: JSON.stringify(playerList, undefined, 4),
        message: `Adding player "${playerUsername}"`,
        path: filename,
        sha: playerListBlob.sha,
    }]);

    return newPlayer;
}

function createPlayer(displayName: string, username: string, existingPlayers: Array<Player>): Player {
    let maxId = 0;
    for (const existingPlayer of existingPlayers) {
        if (existingPlayer.id > maxId) {
            maxId = existingPlayer.id;
        }

        if (existingPlayer.username === username) {
            throw Error(`A player with username "${username}" already exists.`);
        }
    }

    return {
        displayName,
        id: maxId + 1,
        username,
    };
}
