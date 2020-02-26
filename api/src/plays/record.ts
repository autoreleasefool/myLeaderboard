import { Request } from 'express';
import { findMaxId } from '../common/utils';
import Games from '../db/games';
import Players from '../db/players';
import Plays from '../db/plays';
import { Game, Play, Player } from '../lib/types';

export default async function record(req: Request): Promise<Play> {
    const playerIds: Array<number> = typeof(req.body.players) === 'string' ? JSON.parse(req.body.players) : req.body.players;
    const winnerIds: Array<number> = typeof(req.body.winners) === 'string' ? JSON.parse(req.body.winners) : req.body.winners;
    const scores: Array<number> | undefined = req.body.scores != null ? (typeof(req.body.scores) === 'string' ? JSON.parse(req.body.scores) : req.body.scores) : undefined;
    const game: number = req.body.game;

    return recordPlay(playerIds, winnerIds, scores, game);
}

export async function recordPlay(playerIds: Array<number>, winnerIds: Array<number>, scores: Array<number> | undefined, game: number): Promise<Play> {
    if (playerIds.length === 0) {
        throw new Error('No players.');
    } else if (winnerIds.length === 0) {
        throw new Error('No winners.');
    }

    validateGameExists(game, await Games.getInstance().all({}));
    validateWinnersExist(winnerIds, playerIds);

    const existingPlayers = await Players.getInstance().all({});
    const players = mapPlayerIdsToNames(playerIds, existingPlayers);

    const playList = Plays.getInstance().all({});
    const maxId = findMaxId(playList);

    const newPlay: Play = {
        game,
        id: maxId + 1,
        playedOn: new Date().toISOString(),
        players: playerIds,
        winners: winnerIds,
    };

    if (scores != null) {
        newPlay.scores = scores;
    }

    const playerList = Array.from(players)
            .sort((first, second) => first.toLowerCase().localeCompare(second.toLowerCase()))
            .join(', ');

    Plays.getInstance().add(newPlay, `Recording game between ${playerList}`);

    return newPlay;
}

function mapPlayerIdsToNames(ids: Array<number>, existingPlayers: Array<Player>): Array<string> {
    const names: Array<string> = [];
    for (const id of ids) {
        let idFound = false;
        for (const existingPlayer of existingPlayers) {
            if (existingPlayer.id === id) {
                names.push(existingPlayer.username);
                idFound = true;
                break;
            }
        }

        if (!idFound) {
            throw new Error(`Player "${id}" does not exist.`);
        }
    }

    return names;
}

function validateWinnersExist(winners: Array<number>, players: Array<number>): void {
    for (const winnerId of winners) {
        let idFound = false;
        for (const playerId of players) {
            if (winnerId === playerId) {
                idFound = true;
                break;
            }
        }

        if (!idFound) {
            throw new Error(`Winner "${winnerId}" does not exist.`);
        }
    }
}

function validateGameExists(id: number, games: Array<Game>): void {
    for (const game of games) {
        if (game.id === id) {
            return;
        }
    }

    throw new Error(`Game "${id}" does not exist.`);
}
