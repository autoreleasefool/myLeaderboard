import { Request } from 'express';
import Plays from '../db/plays';
import { VsRecord } from '../lib/types';

export default async function record(req: Request): Promise<VsRecord> {
    const playerId = req.params.playerId;
    const gameId = req.params.gameId;

    const playerRecord: VsRecord = {};
    const plays = await Plays.getInstance().all();
    plays.filter(play => play.game === gameId && play.players.includes(playerId))
        .forEach(play => {
            play.players.filter(opponent => opponent !== playerId)
                .forEach(opponent => {
                    if (playerRecord[opponent] == null) {
                        playerRecord[opponent] = { wins: 0, losses: 0, ties: 0};
                    }

                    if (play.winners.length > play.players.length) {
                        if (play.winners.includes(playerId)) {
                            playerRecord[opponent].wins += 1;
                        } else {
                            playerRecord[opponent].losses += 1;
                        }
                    } else {
                        playerRecord[opponent].ties += 1;
                    }
                });
        });

    return playerRecord;
}
