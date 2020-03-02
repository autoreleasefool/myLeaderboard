import { Request } from 'express';
import Plays from '../db/plays';
import { PlayerStandings, Record } from '../lib/types';
import { parseID } from '../common/utils';
import DataLoader, { MyLeaderboardLoader } from '../graphql/DataLoader';

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

export default async function record(req: Request): Promise<PlayerStandings> {
    const playerId = parseID(req.params.playerId);
    const gameId = parseID(req.params.gameId);
    const loader = DataLoader();
    return playerRecord(playerId, gameId, loader);
}

export async function playerRecord(playerId: number, gameId: number, loader: MyLeaderboardLoader): Promise<PlayerStandings> {
    const playerRecord: PlayerStandings = { overallRecord: { wins: 0, losses: 0, ties: 0 }, records: {}};

    // Ensure that the player exists
    await loader.playerLoader.load(playerId)

    const game = await loader.gameLoader.load(gameId);
    const plays = await Plays.getInstance().all({first: -1, offset: 0});

    let gamesPlayed = 0;
    let gamesWithScores = 0;
    let totalScore = 0;
    let bestScore = -Infinity;
    let worstScore = Infinity;

    plays.filter(play => play.game === gameId && play.players.includes(playerId))
        .forEach(play => {
            gamesPlayed += 1;
            const playerIndex = play.players.indexOf(playerId);
            if (playerIndex >= 0 && game.hasScores && play.scores != null && play.scores.length > playerIndex) {
                gamesWithScores += 1;
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
                    if (playerRecord.records[opponent] == null) {
                        playerRecord.records[opponent] = { wins: 0, losses: 0, ties: 0 };
                    }

                    if (playerResult === GameResult.WON) {
                        playerRecord.records[opponent].wins += 1;
                    } else if (playerResult === GameResult.LOST) {
                        playerRecord.records[opponent].losses += 1;
                    } else if (playerResult === GameResult.TIED) {
                        playerRecord.records[opponent].ties += 1;
                    }
                });
        });

    if (game.hasScores && totalScore > 0) {
        playerRecord.scoreStats = {
            average: totalScore / gamesWithScores,
            best: bestScore,
            gamesPlayed,
            worst: worstScore,
        };
    }

    highlightRecords(playerRecord);

    return playerRecord;
}

function highlightRecords(standings: PlayerStandings): void {
    const worstVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: Infinity, losses: 0, wins: 0 }];
    const bestVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: -Infinity, losses: 0, wins: 0 }];
    const opponentIds: Array<number> = [];
    for (const recordAgainstOpponent in standings.records) {
        if (Object.prototype.hasOwnProperty.call(standings.records, recordAgainstOpponent)) {
            opponentIds.push(parseID(recordAgainstOpponent));
        }
    }

    for (const opponentId of opponentIds) {
        const vsRecord = standings.records[opponentId];
        if (vsRecord === null) {
            continue;
        }

        const vsTotalGames = vsRecord.wins + vsRecord.losses + vsRecord.ties;
        const vsWinRate = Math.floor(vsRecord.wins / vsTotalGames * 100);

        const vsRecordForHighlight = { player: opponentId, winRate: vsWinRate, losses: vsRecord.losses, wins: vsRecord.wins };
        updateHighlightedRecords(vsRecordForHighlight, bestVsRecords, worstVsRecords);
    }

    const playerVs: Map<number, Record> = new Map();
    for (const opponentId of opponentIds) {
        playerVs.set(opponentId, standings.records[opponentId]);
    }

    markBestAndWorstRecords(playerVs, bestVsRecords, worstVsRecords);
}

function updateHighlightedRecords(recordHighlight: RecordHighlight, bestRecords: Array<RecordHighlight>, worstRecords: Array<RecordHighlight>): void {
    if (recordHighlight.winRate > bestRecords[0].winRate) {
        bestRecords.length = 0;
        bestRecords.push(recordHighlight);
    } else if (recordHighlight.winRate === bestRecords[0].winRate) {
        if (recordHighlight.wins > bestRecords[0].wins) {
            bestRecords.length = 0;
            bestRecords.push(recordHighlight);
        } else if (recordHighlight.wins === bestRecords[0].wins) {
            bestRecords.push(recordHighlight);
        }
    }
    if (recordHighlight.winRate < worstRecords[0].winRate) {
        worstRecords.length = 0;
        worstRecords.push(recordHighlight);
    } else if (recordHighlight.winRate === worstRecords[0].winRate) {
        if (recordHighlight.losses > worstRecords[0].losses) {
            worstRecords.length = 0;
            worstRecords.push(recordHighlight);
        } else if (recordHighlight.losses === worstRecords[0].losses) {
            worstRecords.push(recordHighlight);
        }
    }
}

function markBestAndWorstRecords(records: Map<number, Record>, bestRecords: Array<RecordHighlight>, worstRecords: Array<RecordHighlight>): void {
    for (const player of records.keys()) {
        const playerRecord = records.get(player);
        if (!playerRecord) {
            continue;
        }

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
