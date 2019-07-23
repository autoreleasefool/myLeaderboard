import { Request } from 'express';
import { checkCache } from '../common/utils';
import Games from '../db/games';
import Players from '../db/players';
import Plays from '../db/plays';
import { Game, GameStandings, Player, Record } from '../lib/types';

let cacheFreshness = new Date();
const cachedStandings: Map<number, GameStandings> = new Map();

enum GameResult {
    WON,
    LOST,
    TIED,
}

interface RecordHighlight {
    player: number | undefined;
    winRate: number;
    losses: number;
    wins: number;
}

export default async function generateGameStandings(req: Request): Promise<GameStandings> {
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

    const gameStandings = await buildStandings(game);
    const allPlayers = await Players.getInstance().all();
    const players = allPlayers.filter(player => gameStandings[player.id] != null);
    highlightRecords(gameStandings, players);

    cachedStandings.set(gameId, gameStandings);
    return gameStandings;
}

async function buildStandings(game: Game): Promise<GameStandings> {
    const gameStandings: GameStandings = {};

    let totalGames = 0;
    let totalScore = 0;
    let bestScore = -Infinity;
    let worstScore = Infinity;

    const plays = Plays.getInstance().all();
    plays.filter(play => play.game === game.id)
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

function highlightRecords(standings: GameStandings, players: Array<Player>) {
    const worstRecords: Array<RecordHighlight> = [{ player: undefined, winRate: Infinity, losses: 0, wins: 0 }];
    const bestRecords: Array<RecordHighlight> = [{ player: undefined, winRate: -Infinity, losses: 0, wins: 0 }];

    for (const player of players) {
        const playerDetails = standings[player.id];
        if (playerDetails == null) {
            continue;
        }

        const totalGames = playerDetails.overallRecord.wins + playerDetails.overallRecord.losses + playerDetails.overallRecord.ties;
        const winRate = Math.floor(playerDetails.overallRecord.wins / totalGames * 100);

        const playerRecordForHighlight = { player: player.id, winRate, losses: playerDetails.overallRecord.losses, wins: playerDetails.overallRecord.wins };
        updateHighlightedRecords(playerRecordForHighlight, bestRecords, worstRecords);

        const worstVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: Infinity, losses: 0, wins: 0 }];
        const bestVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: -Infinity, losses: 0, wins: 0 }];
        for (const opponent of players) {
            const vsRecord = playerDetails.record[opponent.id];
            if (opponent.id === player.id || vsRecord == null) {
                continue;
            }

            const vsTotalGames = vsRecord.wins + vsRecord.losses + vsRecord.ties;
            const vsWinRate = Math.floor(vsRecord.wins / vsTotalGames * 100);

            const vsRecordForHighlight = { player: opponent.id, winRate: vsWinRate, losses: vsRecord.losses, wins: vsRecord.wins };
            updateHighlightedRecords(vsRecordForHighlight, bestVsRecords, worstVsRecords);
        }

        const playerVs: Map<number, Record> = new Map();
        for (const opponent of players) {
            if (opponent.id === player.id) {
                continue;
            }

            playerVs.set(opponent.id, playerDetails.record[opponent.id]);
        }

        markBestAndWorstRecords(playerVs, bestVsRecords, worstVsRecords);
    }

    const playerTotals: Map<number, Record> = new Map();
    for (const player of players) {
        playerTotals.set(player.id, standings[player.id].overallRecord);
    }
    markBestAndWorstRecords(playerTotals, bestRecords, worstRecords);
}

function updateHighlightedRecords(record: RecordHighlight, bestRecords: Array<RecordHighlight>, worstRecords: Array<RecordHighlight>) {
    if (record.winRate > bestRecords[0].winRate) {
        bestRecords.length = 0;
        bestRecords.push(record);
    } else if (record.winRate === bestRecords[0].winRate) {
        if (record.wins > bestRecords[0].wins) {
            bestRecords.length = 0;
            bestRecords.push(record);
        } else if (record.wins === bestRecords[0].wins) {
            bestRecords.push(record);
        }
    }
    if (record.winRate < worstRecords[0].winRate) {
        worstRecords.length = 0;
        worstRecords.push(record);
    } else if (record.winRate === worstRecords[0].winRate) {
        if (record.losses > worstRecords[0].losses) {
            worstRecords.length = 0;
            worstRecords.push(record);
        } else if (record.losses === worstRecords[0].losses) {
            worstRecords.push(record);
        }
    }
}

function markBestAndWorstRecords(records: Map<number, Record>, bestRecords: Array<RecordHighlight>, worstRecords: Array<RecordHighlight>) {
    for (const player of records.keys()) {
        const playerRecord = records.get(player)!;

        for (const best of bestRecords) {
            if (best.player === player) {
                playerRecord.isBest = true;
                break;
            }
        }

        for (const worst of worstRecords) {
            if (worst.player === player) {
                playerRecord.isWorst = true;
                break;
            }
        }
    }
}
