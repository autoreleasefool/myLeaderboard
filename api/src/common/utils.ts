import { PlayNext, PlayerNext, GameNext } from '../lib/types';
import { Request } from 'express';

export function parseID(id: string): number {
    return parseInt(id, 10);
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

export function isPlayer(item: any): item is PlayerNext {
    return item.displayName && item.username;
}

export function isGame(item: any): item is GameNext {
    return item.name && item.hasScores !== undefined;
}

export function isPlay(item: any): item is PlayNext {
    return item.game !== undefined && item.players !== undefined;
}

function getNumberParam(name: string, req: Request, minValue: number, defaultValue: number): number {
    const value = parseInt(req.params[name]);
    return value < minValue ? value : defaultValue;
}

export function getListParams(req: Request): Array<number> {
    return [
        getNumberParam('first', req, 1, 25),
        getNumberParam('offset', req, 0, 0),
    ];
}
