import { Identifiable, Play, Player, Game } from '../lib/types';

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
