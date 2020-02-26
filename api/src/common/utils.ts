import { Identifiable, PlayerRecord, PlayerRecordGraphQL, GameStandingsGraphQL, PlayerStandings, PlayerStandingsGraphQL, GameStandings, PlayGraphQL, Play } from '../lib/types';
import Players from '../db/players';
import Games from '../db/games';

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

export async function playerRecordToGraphQL(playerRecord: PlayerRecord): Promise<PlayerRecordGraphQL> {
    const opponents = await Promise.all(
        Object.keys(playerRecord.records)
            .map(id => parseInt(id, 10))
            .map(id => Players.getInstance().findByIdWithAvatar(id))
    );

    return {
        scoreStats: playerRecord.scoreStats,
        lastPlayed: playerRecord.lastPlayed,
        overallRecord: playerRecord.overallRecord,
        records: filterDefined(opponents)
            .map(player => ({
                player,
                record: playerRecord.records[player.id],
            })),
    };
}

export async function gameStandingsToGraphQL(gameStandings: GameStandings): Promise<GameStandingsGraphQL> {
    const players = await Promise.all(
        Object.keys(gameStandings.records)
            .map(id => parseInt(id, 10))
            .map(id => Players.getInstance().findByIdWithAvatar(id))
    );

    return {
        scoreStats: gameStandings.scoreStats,
        records: await Promise.all(filterDefined(players)
            .map(async player => ({
                player,
                record: await playerRecordToGraphQL(gameStandings.records[player.id]),
            }))),
    };
}

export function playerStandingsToGraphQL(playerStandings: PlayerStandings): PlayerStandingsGraphQL {
    const opponents = Object.keys(playerStandings.records).map(id => parseInt(id, 10));

    return {
        scoreStats: playerStandings.scoreStats,
        overallRecord: playerStandings.overallRecord,
        records: filterDefined(opponents.map(id => Players.getInstance().findById(id)))
            .map(player => ({
                player,
                record: playerStandings.records[player.id],
            })),
    };
}

export async function playToGraphQL(play: Play): Promise<PlayGraphQL | undefined> {
    const players = filterDefined(await Promise.all(
        play.players.map(id => Players.getInstance().findByIdWithAvatar(id))
    ));

    const game = Games.getInstance().findByIdWithImage(play.game);
    if (!game) {
        return undefined;
    }

    return {
        ...play,
        players,
        game,
        winners: players.filter(player => player.id in play.winners),
    };
}
