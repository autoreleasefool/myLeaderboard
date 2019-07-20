import { Request } from 'express';
import { findMaxId } from '../common/utils';
import Octo from '../lib/Octo';
import { Game, Play, Player } from '../lib/types';

export default async function record(req: Request): Promise<void> {
    const playerIds: Array<number> = typeof(req.body.players) === 'string' ? JSON.parse(req.body.players) : req.body.players;
    const winnerIds: Array<number> = typeof(req.body.winners) === 'string' ? JSON.parse(req.body.winners) : req.body.winners;
    const scores: Array<number> = req.body.scores != null ? (typeof(req.body.scores) === 'string' ? JSON.parse(req.body.scores) : req.body.scores) : null;
    const game: number = req.body.game;

    if (playerIds.length === 0) {
        throw new Error('No players.');
    } else if (winnerIds.length === 0) {
        throw new Error('No winners.');
    }

    validateGameExists(game, await Octo.getInstance().games());
    validateWinnersExist(winnerIds, playerIds);

    const existingPlayers = await Octo.getInstance().players(false);
    const players = mapPlayerIdsToNames(playerIds, existingPlayers);

    const filename = `db/plays.json`;
    const playListBlob = await Octo.getInstance().blob(filename);
    const playList: Array<Play> = JSON.parse(playListBlob.content);
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

    playList.push(newPlay);

    const playerList = Array.from(players)
            .sort((first, second) => first.toLowerCase().localeCompare(second.toLowerCase()))
            .join(', ');

    await Octo.getInstance().write([{
        content: stringifyPlayList(playList),
        message: `Recording game between ${playerList}`,
        path: filename,
        sha: playListBlob.sha,
    }]);
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

function validateWinnersExist(winners: Array<number>, players: Array<number>) {
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

function validateGameExists(id: number, games: Array<Game>) {
    for (const game of games) {
        if (game.id === id) {
            return;
        }
    }

    throw new Error(`Game "${id}" does not exist.`);
}

function stringifyPlayList(plays: Array<Play>): string {
    let output = '[\n';
    for (const play of plays) {
        output += JSON.stringify(play);
        output += '\n';
    }
    output += ']';
    return output;
}
