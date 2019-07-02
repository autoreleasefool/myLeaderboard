import { Request } from 'express';
import Octo from '../lib/Octo';
import { GameStandings, VsRecord } from '../lib/types';

export default async function add(req: Request): Promise<void> {
    const gameName = req.body.name;
    if (gameName == null || gameName.length === 0) {
        throw new Error('Missing "name".');
    }

    const gameStandings: GameStandings = {
        players: [],
        records: {},
    };

    const allPlayers = await Octo.getInstance().players();

    for (const player of allPlayers) {
        gameStandings.players.push({
            displayName: player.displayName,
            lastPlayed: new Date(0).toISOString(),
            username: player.username,
        });

        const playerRecord: VsRecord = {};
        for (const opponent of allPlayers) {
            if (player.username === opponent.username) {
                continue;
            }

            playerRecord[opponent.username] = { wins: 0, losses: 0, ties: 0 };
        }
        gameStandings.records[player.username] = playerRecord;
    }

    await Octo.getInstance().write([{
        content: JSON.stringify(gameStandings, undefined, 4),
        message: `Adding game ${gameName}`,
        path: `data/${gameName}.json`,
    }]);
}
