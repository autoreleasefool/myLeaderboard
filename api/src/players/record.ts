import { Request } from 'express';
import Games from '../db/games';
import Plays from '../db/plays';
import { PlayerStandings } from '../lib/types';

export default async function record(req: Request): Promise<PlayerStandings> {
    const playerId = req.params.playerId;
    const gameId = req.params.gameId;

    const game = Games.getInstance().findById(gameId);
    if (game == null) {
        return {};
    }

    const playerRecord: PlayerStandings = {};
    const plays = await Plays.getInstance().all();

    let gamesPlayed = 0;
    let totalScore = 0;
    let bestScore = -Infinity;
    let worstScore = Infinity;

    plays.filter(play => play.game === gameId && play.players.includes(playerId))
        .forEach(play => {
            gamesPlayed += 1;
            const playerIndex = play.players.indexOf(playerId);
            if (playerIndex >= 0 && game.hasScores && play.scores != null && play.scores.length > playerIndex) {
                const playerScore = play.scores[playerIndex];
                totalScore += playerScore;
                if (playerScore > bestScore) {
                    bestScore = playerScore;
                }
                if (playerScore < worstScore) {
                    worstScore = playerScore;
                }
            }

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

    if (game.hasScores && totalScore > 0) {
        playerRecord.scoreStats = {
            average: totalScore / gamesPlayed,
            best: bestScore,
            gamesPlayed,
            worst: worstScore,
        };
    }

    return playerRecord;
}
