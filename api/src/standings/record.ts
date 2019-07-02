import { Request } from 'express';
import { allGames } from '../lib/Game';
import Octo, { Writeable } from '../lib/Octo';
import { GameStandings } from '../lib/types';

export default async function record(req: Request): Promise<void> {
    const gamePlayers: Set<string> = new Set(req.body.players);
    const gameWinners: Set<string> = new Set(req.body.winners);
    const game: string = req.body.game;

    if (gamePlayers.size === 0) {
        throw new Error('No players.');
    } else if (gameWinners.size === 0) {
        throw new Error('No winners.');
    } else if (game.length === 0) {
        throw new Error('No game.');
    }

    validateGameExists(game, await allGames());
    validateWinnersExist(gameWinners, gamePlayers);

    const players = await Octo.getInstance().players(game);
    const playerNames = new Set(players.map(player => player.username));

    validatePlayersExist(gamePlayers, playerNames);
    validatePlayersExist(gameWinners, playerNames);

    const filesToWrite: Array<Writeable> = [];
    const updatedStandings = await writeableGameStandingsWithUpdate(gamePlayers, gameWinners, game);
    filesToWrite.push(updatedStandings);

    Octo.getInstance().write(filesToWrite);
}

enum GameResult {
    WON,
    LOST,
    TIED,
}

async function writeableGameStandingsWithUpdate(players: Set<string>, winners: Set<string>, game: string): Promise<Writeable> {
    const filename = `data/${game}.json`;
    const gameStandingsBlob = await Octo.getInstance().blob(filename);
    const gameStandings: GameStandings = JSON.parse(gameStandingsBlob.content);

    for (const player of players) {
        let result: GameResult;
        if (winners.size === players.size) {
            result = GameResult.TIED;
        } else if (winners.has(player)) {
            result = GameResult.WON;
        } else {
            result = GameResult.LOST;
        }

        for (const opponent of players) {
            if (opponent === player) {
                continue;
            }

            switch (result) {
            case GameResult.WON:
                gameStandings.records[player][opponent].wins += 1;
                break;
            case GameResult.LOST:
                gameStandings.records[player][opponent].losses += 1;
                break;
            case GameResult.TIED:
                gameStandings.records[player][opponent].ties += 1;
                break;
            }
        }
    }

    for (const player of players) {
        for (const gamePlayer of gameStandings.players) {
            if (player === gamePlayer.username) {
                gamePlayer.lastPlayed = new Date().toISOString();
            }
        }
    }

    const playerList = Array.from(players)
            .map(name => name.charAt(0) === '@' ? name.substr(1) : name)
            .sort((first, second) => first.toLowerCase().localeCompare(second.toLowerCase()))
            .join(', ');

    return {
        content: JSON.stringify(gameStandings, undefined, 4),
        message: `Recording game between ${playerList}`,
        path: filename,
        sha: gameStandingsBlob.sha,
    };
}

function validatePlayersExist(players: Set<string>, existingPlayers: Set<string>) {
    for (const player of players) {
        if (existingPlayers.has(player) === false) {
            throw new Error(`Player "${player}" does not exist.`);
        }
    }
}

function validateWinnersExist(winners: Set<string>, players: Set<string>) {
    for (const winner of winners) {
        if (players.has(winner) === false) {
            throw new Error(`Winner "${winner}" does not exist in players.`);
        }
    }
}

function validateGameExists(game: string, games: Array<string>) {
    if (games.indexOf(game) < 0) {
        throw new Error(`Game "${game}" does not exist.`);
    }
}
