import { Octo } from "./octo";

export type Player = string;

export enum Game {
    Hive = "Hive",
    Patchwork = "Patchwork",
}

export interface Record {
    wins: number;
    losses: number;
    ties: number;
    isBest: boolean;
    isWorst: boolean;
}

export interface Standings {
    game: Game;
    players: Array<Player>;
    playerRecords: Map<Player, Record>;
    records: Map<Player, Map<Player, Record>>;
}

export interface RawStandings {
    [key: string]: {
        [key: string]: string;
    };
}

export async function fetchPlayers(): Promise<Array<Player>> {
    let rawPlayers = await Octo.contents("names.txt");
    return parseRawPlayers(rawPlayers);
}

function parseRawPlayers(contents: string): Array<Player> {
    let players: Array<Player> = contents.toLowerCase().split("\n").filter(x => x.length > 0)
    return players.sort()
}

export async function fetchStandings(game: Game): Promise<Standings> {
    let rawStandings = await Octo.contents(`standings/${game}.json`);
    return parseRawStandings(game, rawStandings);
}

interface HighlightedRecord { player?: Player, record: number }

function parseRawStandings(game: Game, contents: string): Standings {
    let json: RawStandings = JSON.parse(contents.toLowerCase());
    let players: Array<Player> = [];
    let overallRecords: Map<Player, Record> = new Map();
    let headToHeadRecords: Map<Player, Map<Player, Record>> = new Map();

    let bestRecords: Array<HighlightedRecord> = [{ player: null, record: -Infinity }];
    let worstRecords: Array<HighlightedRecord> = [{ player: null, record: Infinity }];
    for (let player in json) {
        players.push(player);
        let playerOverallRecord: Record = { wins: 0, losses: 0, ties: 0, isBest: false, isWorst: false };

        let bestOpponentRecords: Array<HighlightedRecord> = [{ player: null, record: -Infinity }];
        let worstOpponentRecords: Array<HighlightedRecord> = [{ player: null, record: Infinity }];
        for (let opponent in json[player]) {
            const rawRecord = json[player][opponent];
            const [wins, losses, ties] = rawRecord.split("-").map(x => parseInt(x));

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
            updateHighlightedRecords({ player: opponent, record: winRate}, bestOpponentRecords, worstOpponentRecords);
        }

        let playerRecords = headToHeadRecords.get(player);
        let opponents = Object.keys(json[player]);
        markBestAndWorstRecords(playerRecords, opponents, bestOpponentRecords, worstOpponentRecords);

        overallRecords.set(player, playerOverallRecord);

        const totalGames = playerOverallRecord.wins + playerOverallRecord.losses + playerOverallRecord.ties
        const winRate = totalGames > 0 ? playerOverallRecord.wins / totalGames : 0;
        updateHighlightedRecords({ player, record: winRate }, bestRecords, worstRecords);
    }

    markBestAndWorstRecords(overallRecords, players, bestRecords, worstRecords);

    players.sort();

    let standings: Standings = { game, players, playerRecords: overallRecords, records: headToHeadRecords };
    stripUnplayedPlayers(standings);
    return standings;
}

function stripUnplayedPlayers(standings: Standings) {
    let players = Array.from(standings.players);
    for (let player of players) {
        let playerRecord = standings.playerRecords.get(player);
        if (playerRecord.wins + playerRecord.losses + playerRecord.ties == 0) {
            standings.players = standings.players.filter(x => x !== player);
            standings.playerRecords.delete(player);
            standings.records.delete(player);
            for (let opponent of standings.players) {
                let opponentRecord = standings.records.get(opponent);
                opponentRecord.delete(player);
            }
        }
    }
}

function markBestAndWorstRecords(records: Map<Player, Record>, players: Array<Player>, bestRecords: Array<HighlightedRecord>, worstRecords: Array<HighlightedRecord>) {
    for (let player of players) {
        let playerRecord = records.get(player)

        for (let best of bestRecords) {
            if (best.player == player) {
                playerRecord.isBest = true
                break;
            }
        }

        for (let worst of worstRecords) {
            if (worst.player == player) {
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

export function formatRecord(record: Record): string {
    let format = `<span class="record--value record--wins">${record.wins}</span>-<span class="record--value record--losses">${record.losses}</span>`;
    if (record.ties > 0) {
        format += `-<span class="record--value record--ties">${record.ties}</span>`;
    }
    return format;
}
