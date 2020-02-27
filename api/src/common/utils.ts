import { Identifiable, PlayerRecord, PlayerRecordGraphQL, GameStandingsGraphQL, PlayerStandings, PlayerStandingsGraphQL, GameStandings, PlayGraphQL, Play, Player, Game } from '../lib/types';
import { MyLeaderboardLoader } from '../graphql/dataloader';

export function parseID(id: string): number {
    return parseInt(id, 10);
}

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

export function filterDefined<T>(
    array: (T | null | undefined)[] | null | undefined
): NonNullable<T>[] {
    return (
        (array &&
            array.filter(
                (item): item is NonNullable<T> => item !== null && item !== undefined
            )) ||
        []
    );
}

export function isPlayer(item: any): item is Player {
    return item.displayName && item.username;
}

export function isGame(item: any): item is Game {
    return item.name && item.hasScores !== undefined;
}

export function isPlay(item: any): item is Play {
    return item.game !== undefined && item.players !== undefined;
}

export async function playerRecordToGraphQL(playerRecord: PlayerRecord, loader: MyLeaderboardLoader): Promise<PlayerRecordGraphQL> {
    const playerIds = Object.keys(playerRecord.records);
    const players = await loader.playerLoader.loadMany(playerIds);

    return {
        scoreStats: playerRecord.scoreStats,
        lastPlayed: playerRecord.lastPlayed,
        overallRecord: playerRecord.overallRecord,
        records: players.filter(player => isPlayer(player))
            .map(player => player as Player)
            .map(player => ({
                player,
                record: playerRecord.records[player.id],
            })),
    };
}

export async function gameStandingsToGraphQL(gameStandings: GameStandings, loader: MyLeaderboardLoader): Promise<GameStandingsGraphQL> {
    const playerIds = Object.keys(gameStandings.records);
    const players = await loader.playerLoader.loadMany(playerIds);

    return {
        scoreStats: gameStandings.scoreStats,
        records: await Promise.all(players.filter(player => isPlayer(player))
            .map(player => player as Player)
            .map(async player => ({
                player,
                record: await playerRecordToGraphQL(gameStandings.records[player.id], loader),
            }))),
    };
}

export async function playerStandingsToGraphQL(playerStandings: PlayerStandings, loader: MyLeaderboardLoader): Promise<PlayerStandingsGraphQL> {
    const playerIds = Object.keys(playerStandings.records);
    const players = await loader.playerLoader.loadMany(playerIds);

    return {
        scoreStats: playerStandings.scoreStats,
        overallRecord: playerStandings.overallRecord,
        records: players.filter(player => isPlayer(player))
            .map(player => player as Player)
            .map(player => ({
                player,
                record: playerStandings.records[player.id],
            })),
    };
}

export async function playToGraphQL(play: Play, loader: MyLeaderboardLoader): Promise<PlayGraphQL | undefined> {
    const playerIds = play.players.map(id => String(id));
    const players = await loader.playerLoader.loadMany(playerIds);

    const game = await loader.gameLoader.load(String(play.game));
    if (!game) {
        return undefined;
    }

    return {
        ...play,
        players: players.filter(player => isPlayer(player))
            .map(player => player as Player),
        game,
        winners: players.filter(player => isPlayer(player))
            .map(player => player as Player)
            .filter(player => player.id in play.winners),
    };
}
