import { Request } from 'express';
import { checkCache } from '../common/utils';
import Games from '../db/games';
import Players from '../db/players';
import Plays from '../db/plays';
import { PlayerStandings } from '../lib/types';

let cacheFreshness = new Date();
const cachedStandings: Map<number, PlayerStandings> = new Map();

enum GameResult {
    WON,
    LOST,
    TIED,
}

export default async function record(req: Request): Promise<PlayerStandings> {
    const playerId = parseInt(req.params.playerId, 10);
    const gameId = parseInt(req.params.gameId, 10);
    const key = playerId * 1000 + gameId;

    const dependencies = [Plays.getInstance()];
    const cachedValue = await checkCache(cachedStandings, key, cacheFreshness, dependencies);
    if (cachedValue != null) {
        return cachedValue;
    }
    cacheFreshness = new Date();

    const player = Players.getInstance().findById(playerId);
    if (player == null) {
        return { overallRecord: { wins: 0, losses: 0, ties: 0 }};
    }

    const game = Games.getInstance().findById(gameId);
    if (game == null) {
        return { overallRecord: { wins: 0, losses: 0, ties: 0 }};
    }

    const playerRecord: PlayerStandings = { overallRecord: { wins: 0, losses: 0, ties: 0 }};
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

            let playerResult: GameResult;
            if (play.winners.length < play.players.length) {
                if (play.winners.includes(playerId)) {
                    playerResult = GameResult.WON;
                    playerRecord.overallRecord.wins += 1;
                } else {
                    playerResult = GameResult.LOST;
                    playerRecord.overallRecord.losses += 1;
                }
            } else {
                playerResult = GameResult.TIED;
                playerRecord.overallRecord.ties += 1;
            }

            play.players.filter(opponent => opponent !== playerId)
                .forEach(opponent => {
                    if (playerRecord[opponent] == null) {
                        playerRecord[opponent] = { wins: 0, losses: 0, ties: 0 };
                    }

                    if (playerResult === GameResult.WON) {
                        playerRecord[opponent].wins += 1;
                    } else if (playerResult === GameResult.LOST) {
                        playerRecord[opponent].losses += 1;
                    } else if (playerResult === GameResult.TIED) {
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

    cachedStandings.set(key, playerRecord);
    return playerRecord;
}
