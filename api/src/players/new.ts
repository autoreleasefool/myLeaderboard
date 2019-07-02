import { allGames, Game } from '../lib/Game';
import Octo, { Writeable } from '../lib/Octo';
import { GameStandings, VsRecord } from '../lib/types';

export default async function add(playerName: string, playerUsername: string): Promise<void> {
    const filesToWrite: Array<Writeable> = [];

    if (playerUsername.charAt(0) !== '@') {
        playerUsername = `@${playerUsername}`;
    }

    for (const gameName of allGames()) {
        const game = gameName as Game;
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

async function writeableGameStandingsWithNewPlayer(displayName: string, username: string, game: Game): Promise<Writeable> {
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
