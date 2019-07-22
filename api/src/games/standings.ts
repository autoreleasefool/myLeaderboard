import { Request } from 'express';
import { checkCache } from '../common/utils';
import Games from '../db/games';
import Plays from '../db/plays';
import { GameStandings } from '../lib/types';

let cacheFreshness = new Date();
const cachedStandings: Map<number, GameStandings> = new Map();

enum GameResult {
    WON,
    LOST,
    TIED,
}

export default async function standings(req: Request): Promise<GameStandings> {
    const gameId = parseInt(req.params.id, 10);

    const dependencies = [Plays.getInstance()];
    const cachedValue = await checkCache(cachedStandings, gameId, cacheFreshness, dependencies);
    if (cachedValue != null) {
        return cachedValue;
    }
    cacheFreshness = new Date();

    const game = Games.getInstance().findById(gameId);
    if (game == null) {
        return {};
    }

    let totalGames = 0;
    let totalScore = 0;
    let bestScore = -Infinity;
    let worstScore = Infinity;

    const gameStandings: GameStandings = {};

    const plays = Plays.getInstance().all();
    plays.filter(play => play.game === gameId)
        .forEach(play => {
            totalGames += 1;
            if (game.hasScores && play.scores != null) {
                for (const score of play.scores) {
                    totalScore += score;
                    if (score > bestScore) {
                        bestScore = score;
                    }
                    if (score < worstScore) {
                        worstScore = score;
                    }
                }

            }

            play.players.forEach((playerId, index) => {
                if (gameStandings[playerId] == null) {
                    gameStandings[playerId] = {
                        lastPlayed: play.playedOn,
                        overallRecord: { wins: 0, losses: 0, ties: 0 },
                        record: {},
                    };
                }

                if (game.hasScores && play.scores != null && play.scores.length > index) {
                    const playerScore = play.scores[index];
                    const playerStats = gameStandings[playerId].scoreStats;
                    if (playerStats == null) {
                        gameStandings[playerId].scoreStats = {
                            average: playerScore,
                            best: playerScore,
                            gamesPlayed: 1,
                            worst: playerScore,
                        };
                    } else {
                        playerStats.average += playerScore;
                        playerStats.gamesPlayed += 1;
                        if (playerScore > playerStats.best) {
                            playerStats.best = playerScore;
                        }
                        if (playerScore < playerStats.worst) {
                            playerStats.worst = playerScore;
                        }
                    }
                }

                if (play.playedOn > gameStandings[playerId].lastPlayed) {
                    gameStandings[playerId].lastPlayed = play.playedOn;
                }

                let playerResult: GameResult;
                if (play.winners.length < play.players.length) {
                    if (play.winners.includes(playerId)) {
                        playerResult = GameResult.WON;
                        gameStandings[playerId].overallRecord.wins += 1;
                    } else {
                        gameStandings[playerId].overallRecord.losses += 1;
                        playerResult = GameResult.LOST;
                    }
                } else {
                    playerResult = GameResult.TIED;
                    gameStandings[playerId].overallRecord.ties += 1;
                }

                play.players.filter(opponent => opponent !== playerId)
                    .forEach(opponent => {
                        if (gameStandings[playerId].record[opponent] == null) {
                            gameStandings[playerId].record[opponent] = { wins: 0, losses: 0, ties: 0 };
                        }

                        if (playerResult === GameResult.WON) {
                            gameStandings[playerId].record[opponent].wins += 1;
                        } else if (playerResult === GameResult.LOST) {
                            gameStandings[playerId].record[opponent].losses += 1;
                        } else if (playerResult === GameResult.TIED) {
                            gameStandings[playerId].record[opponent].ties += 1;
                        }
                    });
            });
        });

    for (const player in gameStandings) {
        if (typeof(player) === 'number' && gameStandings.hasOwnProperty(player)) {
            const playerStats = gameStandings[player].scoreStats;
            if (playerStats != null) {
                playerStats.average = playerStats.average / playerStats.gamesPlayed;
            }
        }
    }

    if (game.hasScores && totalScore > 0) {
        gameStandings.scoreStats = {
            average: totalScore / totalGames,
            best: bestScore,
            gamesPlayed: totalGames,
            worst: worstScore,
        };
    }

    return gameStandings;
}
