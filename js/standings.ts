import { Repo } from "./repo";

export type Player = string;

export enum Game {
    Hive = "Hive",
    Patchwork = "Patchwork",
}

export interface Record {
    wins: number;
    losses: number;
    ties: number;
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

export async function fetchStandings(game: Game): Promise<Standings> {
    let rawStandings = await Repo.contents(`standings/${game}.json`);
    return parseRawStandings(game, rawStandings);
}

function parseRawStandings(game: Game, contents: string): Standings {
    let json: RawStandings = JSON.parse(contents);
    let players: Array<Player> = [];
    let playerRecords: Map<Player, Record> = new Map();
    let matchRecords: Map<Player, Map<Player, Record>> = new Map();

    for (let player in json) {
        players.push(player);
        let playerRecord: Record = { wins: 0, losses: 0, ties: 0 };

        for (let opponent in json[player]) {
            const rawRecord = json[player][opponent];
            const [wins, losses, ties] = rawRecord.split("-").map(x => parseInt(x));

            if (matchRecords.has(player) == false) {
                matchRecords.set(player, new Map());
            }

            let matchRecord = matchRecords.get(player);
            matchRecord.set(opponent, { wins, losses, ties });
            matchRecords.set(player, matchRecord);

            playerRecord.wins += wins;
            playerRecord.losses += losses;
            playerRecord.ties += ties;
        }

        playerRecords.set(player, playerRecord);
    }

    players.sort();

    return {
        game,
        players,
        playerRecords,
        records: matchRecords,
    };
}

export function formatRecord(record: Record): string {
    let format = `<span class="record--value record--wins">${record.wins}</span>-<span class="record--value record--losses">${record.losses}</span>`;
    if (record.ties > 0) {
        format += `-<span class="record--value record--ties">${record.ties}</span>`;
    }
    return format;
}
