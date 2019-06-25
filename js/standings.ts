import { Octo } from "./octo";
import { nameSort } from "./utils";

export enum Game {
    Hive = "Hive",
    Patchwork = "Patchwork",
}

export interface Record {
    wins: number;
    losses: number;
    ties: number;
    isBest?: boolean;
    isWorst?: boolean;
}

export interface Standings {
    game: Game;
    playerNames: Array<string>;
    playerRecords: Map<string, Record>;
    records: Map<string, Map<string, Record>>;
}

export interface RawStandings {
    [key: string]: {
        [key: string]: Record;
    };
}

export async function fetchStandings(game: Game): Promise<Standings> {
    let rawStandings = await Octo.contents(`standings/${game}.json`);
    return parseRawStandings(game, rawStandings);
}

interface HighlightedRecord { playerName?: string, record: number }

function parseRawStandings(game: Game, contents: string): Standings {
    let json: RawStandings = JSON.parse(contents);
    let playerNames: Array<string> = [];
    let overallRecords: Map<string, Record> = new Map();
    let headToHeadRecords: Map<string, Map<string, Record>> = new Map();

    let bestRecords: Array<HighlightedRecord> = [{ playerName: null, record: -Infinity }];
    let worstRecords: Array<HighlightedRecord> = [{ playerName: null, record: Infinity }];
    for (let player in json) {
        playerNames.push(player);
        let playerOverallRecord: Record = { wins: 0, losses: 0, ties: 0, isBest: false, isWorst: false };

        let bestOpponentRecords: Array<HighlightedRecord> = [{ playerName: null, record: -Infinity }];
        let worstOpponentRecords: Array<HighlightedRecord> = [{ playerName: null, record: Infinity }];
        for (let opponent in json[player]) {
            const { wins, losses, ties } = json[player][opponent];

            if (headToHeadRecords.has(player) == false) {
                headToHeadRecords.set(player, new Map());
            }

            let playerRecords = headToHeadRecords.get(player);
            playerRecords.set(opponent, { wins, losses, ties, isBest: false, isWorst: false });

            playerOverallRecord.wins += wins;
            playerOverallRecord.losses += losses;
            playerOverallRecord.ties += ties;

            const totalGames = wins + losses + ties;
            const winRate = totalGames > 0 ? wins / totalGames : 0;
            updateHighlightedRecords({ playerName: opponent, record: winRate}, bestOpponentRecords, worstOpponentRecords);
        }

        let playerRecords = headToHeadRecords.get(player);
        let opponents = Object.keys(json[player]);
        markBestAndWorstRecords(playerRecords, opponents, bestOpponentRecords, worstOpponentRecords);

        overallRecords.set(player, playerOverallRecord);

        const totalGames = playerOverallRecord.wins + playerOverallRecord.losses + playerOverallRecord.ties
        const winRate = totalGames > 0 ? playerOverallRecord.wins / totalGames : 0;
        updateHighlightedRecords({ playerName: player, record: winRate }, bestRecords, worstRecords);
    }

    markBestAndWorstRecords(overallRecords, playerNames, bestRecords, worstRecords);

    playerNames.sort(nameSort);

    let standings: Standings = { game, playerNames, playerRecords: overallRecords, records: headToHeadRecords };
    stripUnplayedPlayers(standings);
    return standings;
}

function stripUnplayedPlayers(standings: Standings) {
    let playerNames = Array.from(standings.playerNames);
    for (let playerName of playerNames) {
        let playerRecord = standings.playerRecords.get(playerName);
        if (playerRecord.wins + playerRecord.losses + playerRecord.ties == 0) {
            standings.playerNames = standings.playerNames.filter(x => x !== playerName);
            standings.playerRecords.delete(playerName);
            standings.records.delete(playerName);
            for (let opponent of standings.playerNames) {
                let opponentRecord = standings.records.get(opponent);
                opponentRecord.delete(playerName);
            }
        }
    }
}

function markBestAndWorstRecords(records: Map<string, Record>, players: Array<string>, bestRecords: Array<HighlightedRecord>, worstRecords: Array<HighlightedRecord>) {
    for (let playerName of players) {
        let playerRecord = records.get(playerName)

        for (let best of bestRecords) {
            if (best.playerName == playerName) {
                playerRecord.isBest = true
                break;
            }
        }

        for (let worst of worstRecords) {
            if (worst.playerName == playerName) {
                playerRecord.isWorst = true
                break;
            }
        }
    }
}

function updateHighlightedRecords(record: HighlightedRecord, bestRecords: Array<HighlightedRecord>, worstRecords: Array<HighlightedRecord>) {
    if (record.record > bestRecords[0].record) {
        bestRecords.length = 0;
        bestRecords.push(record);
    } else if (record.record == bestRecords[0].record) {
        bestRecords.push(record);
    }

    if (record.record < worstRecords[0].record) {
        worstRecords.length = 0;
        worstRecords.push(record);
    } else if (record.record == worstRecords[0].record) {
        worstRecords.push(record)
    }
}
