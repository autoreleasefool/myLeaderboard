import { Identifiable, PlayerRecord, PlayerRecordGraphQL, GameStandingsGraphQL, PlayerStandings, PlayerStandingsGraphQL, GameStandings } from '../lib/types';

export function findMaxId(items: Array<Identifiable>): number {
    let maxId = 0;
    for (const item of items) {
        if (item.id > maxId) {
            maxId = item.id;
        }
    }
    return maxId;
}

export function apiURL(withScheme: boolean): string {
    const baseURL = process.env.API_URL;
    if (!baseURL) {
        throw Error("API URL could not be determined");
    }

    if (baseURL.startsWith('http')) {
        if (withScheme) {
            return baseURL;
        } else {
            return baseURL.substr(baseURL.indexOf('/') + 2);
        }
    } else {
        if (withScheme) {
            if (process.env.SSL_ENABLED) {
                return `https://${baseURL}`;
            } else {
                return `http://${baseURL}`;
            }
        } else {
            return baseURL;
        }
    }
}

export function playerRecordToGraphQL(playerRecord: PlayerRecord): PlayerRecordGraphQL {
    let opponents = Object.keys(playerRecord.records).map(id => parseInt(id, 10));

    return {
        scoreStats: playerRecord.scoreStats,
        lastPlayed: playerRecord.lastPlayed,
        overallRecord: playerRecord.overallRecord,
        records: {
            opponents,
            records: opponents.map(id => playerRecord.records[id]),
        }
    }
}

export function gameStandingsToGraphQL(gameStandings: GameStandings): GameStandingsGraphQL {
    let players = Object.keys(gameStandings.records).map(id => parseInt(id, 10));

    return {
        scoreStats: gameStandings.scoreStats,
        records: {
            players,
            records: players.map(id => playerRecordToGraphQL(gameStandings.records[id])),
        },
    };
}

export function playerStandingsToGraphQL(playerStandings: PlayerStandings): PlayerStandingsGraphQL {
    let opponents = Object.keys(playerStandings.records).map(id => parseInt(id, 10));

    return {
        scoreStats: playerStandings.scoreStats,
        overallRecord: playerStandings.overallRecord,
        records: {
            opponents,
            records: opponents.map(id => playerStandings.records[id]),
        }
    }
}
