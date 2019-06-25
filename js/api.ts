import { Octo, Writeable } from "./octo";
import { getParam } from "./utils";
import { Game, RawStandings } from "./standings";
import { BasicPlayer } from "./player";

export function handleApiCall() {
    const endpoint = getParam("endpoint");
    if (endpoint == "addPlayer") {
        addPlayer();
    } else if (endpoint == "record") {
        recordGame();
    }
}

// Add player

async function addPlayer() {
    if (validateInputExists(["username", "name", "token"]) === false) {
        return;
    }

    let filesToWrite: Array<Writeable> = [];

    let playerUsername = getParam("username");
    const playerName = getParam("name");
    if (playerUsername.charAt(0) !== "@") {
        playerUsername = `@${playerUsername}`;
    }

    let playerList = await writeablePlayerListWithAddedPlayer(playerName, playerUsername);
    filesToWrite.push(playerList);

    for (let gameName in Game) {
        const game = gameName as Game;
        const gameStandings = await writeableGameStandingsWithNewPlayer(playerUsername, game);
        filesToWrite.push(gameStandings);
    }

    Octo.write(filesToWrite);
}

async function writeablePlayerListWithAddedPlayer(name: string, username: string): Promise<Writeable> {
    const filename = "players.json";
    const playersBlob = await Octo.info(filename);
    const rawPlayers = atob(playersBlob.content);
    let players: Array<BasicPlayer> = JSON.parse(rawPlayers);
    players.push({
        name,
        username,
    });

    return {
        path: filename,
        contents: JSON.stringify(players, undefined, 4),
        sha: playersBlob.sha,
        message: `Adding player "${username}" to players`,
    };
}

async function writeableGameStandingsWithNewPlayer(username: string, game: Game): Promise<Writeable> {
    let filename = `standings/${game}.json`;
    const gameStandingsBlob = await Octo.info(filename);
    const rawGameStandings = atob(gameStandingsBlob.content);
    let gameStandings: RawStandings = JSON.parse(rawGameStandings);

    let playerRecord = {};
    for (let existingPlayer of Object.keys(gameStandings)) {
        playerRecord[existingPlayer] = { wins: 0, losses: 0, ties: 0 };
        gameStandings[existingPlayer][username] = { wins: 0, losses: 0, ties: 0 };
    }

    gameStandings[username] = playerRecord;

    return {
        path: filename,
        contents: JSON.stringify(gameStandings, undefined, 4),
        sha: gameStandingsBlob.sha,
        message: `Adding player "${username}" to ${game}`,
    };
}

// Record game

async function recordGame() {
    if (validateInputExists(["players", "winners", "game", "token"]) === false) {
        return;
    }

    const players = JSON.parse(getParam("players"));
    const winners = JSON.parse(getParam("winners"));
    const game = getParam("game") as Game;
}

// Form validation

function validateInputExists(params: Array<string>): boolean {
    for (let param of params) {
        let value = getParam(param);
        if (value == null || value.length === 0) {
            const apiError = missingParamError(param);
            displayApiError(apiError);
            return false;
        }
    }

    return true;
}

// Error handling

interface ApiError {
    title: string;
    message: string;
}

function displayApiError(error: ApiError) {
    let errorHTML = `<div class="error"><h1 class="error-title">${error.title}</h1><p>${error.message}</p></div>`;
    document.querySelector('.api-output').innerHTML = errorHTML;
}

function missingParamError(param: string): ApiError {
    return {
        title: "Missing param!",
        message: `The "${param}" param was missing.`,
    };
}