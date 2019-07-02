import { Request } from 'express';
import { allGames } from '../lib/Game';
import Octo, { Writeable } from '../lib/Octo';
import { GameStandings, VsRecord } from '../lib/types';

export default async function add(req: Request): Promise<void> {
    const playerName = req.body.name;
    let playerUsername = req.body.username;
    if (playerName == null || playerName.length === 0) {
        throw new Error('Missing "name".');
    } else if (playerUsername == null || playerUsername.length === 0) {
        throw new Error('Missing "username".');
    }

    const filesToWrite: Array<Writeable> = [];

    if (playerUsername.charAt(0) !== '@') {
        playerUsername = `@${playerUsername}`;
    }

    const games = await allGames();
    for (const game of games) {
        try {
            const gameStandings = await writeableGameStandingsWithNewPlayer(playerName, playerUsername, game);
            filesToWrite.push(gameStandings);
        } catch (error) {
            throw error;
            return;
        }
    }

    await Octo.getInstance().write(filesToWrite);
}

async function writeableGameStandingsWithNewPlayer(displayName: string, username: string, game: string): Promise<Writeable> {
    const filename = `data/${game}.json`;
    const gameStandingsBlob = await Octo.getInstance().blob(filename);
    const gameStandings: GameStandings = JSON.parse(gameStandingsBlob.content);

    const playerRecord: VsRecord = {};
    for (const existingPlayer of gameStandings.players) {
        if (existingPlayer.username === username) {
            throw new Error(`Player "${existingPlayer.username}" already exists on ${game}`);
        }

        playerRecord[existingPlayer.username] = { wins: 0, losses: 0, ties: 0 };
        gameStandings.records[existingPlayer.username][username] = { wins: 0, losses: 0, ties: 0 };
    }

    gameStandings.records[username] = playerRecord;
    gameStandings.players.push({
        displayName,
        lastPlayed: new Date(0).toISOString(),
        username,
    });

    return {
        content: JSON.stringify(gameStandings, undefined, 4),
        message: `Adding player "${username}" to ${game}`,
        path: filename,
        sha: gameStandingsBlob.sha,
    };
}
