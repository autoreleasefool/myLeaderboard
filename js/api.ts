import { Octo, Writeable } from "./octo";
import { getParam, nameSort } from "./utils";
import { Game, RawStandings } from "./standings";
import { BasicPlayer, fetchPlayers, Player } from "./player";

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

    const gamePlayers: Set<string> = new Set(JSON.parse(getParam("players")));
    const gameWinners: Set<string> = new Set(JSON.parse(getParam("winners")));
    const game = getParam("game") as Game;

    const players = await fetchPlayers();

    if (validatePlayersExist(gamePlayers, players) === false) {
        return;
    }

    if (validatePlayersExist(gameWinners, players) === false) {
        return;
    }

    let filesToWrite: Array<Writeable> = [];
    const updatedStandings = await writeableGameStandingsWithUpdate(gamePlayers, gameWinners, game);
    filesToWrite.push(updatedStandings);

    const updatedLog = await writeablePlayLog(gamePlayers, gameWinners, game);
    filesToWrite.push(updatedLog);

    Octo.write(filesToWrite);
}

enum GameResult {
    WON,
    LOST,
    TIED,
}

async function writeableGameStandingsWithUpdate(players: Set<string>, winners: Set<string>, game: Game): Promise<Writeable> {
    let filename = `standings/${game}.json`;
    const gameStandingsBlob = await Octo.info(filename);
    const rawGameStandings = atob(gameStandingsBlob.content);
    let gameStandings: RawStandings = JSON.parse(rawGameStandings);

    for (let player of players) {
        let result: GameResult;
        if (winners.size === players.size) {
            result = GameResult.TIED;
        } else if (winners.has(player)) {
            result = GameResult.WON;
        } else {
            result = GameResult.LOST;
        }

        for (let opponent of players) {
            if (opponent === player) {
                continue;
            }

            switch(result) {
            case GameResult.WON:
                gameStandings[player][opponent].wins += 1;
                break;
            case GameResult.LOST:
                gameStandings[player][opponent].losses += 1;
                break;
            case GameResult.TIED:
                gameStandings[player][opponent].ties += 1;
                break;
            }
        }
    }

    const playerList = Array.from(players).sort(nameSort).join(", ");

    return {
        path: filename,
        contents: JSON.stringify(gameStandings, undefined, 4),
        sha: gameStandingsBlob.sha,
        message: `Recording game between ${playerList}`,
    };
}

async function writeablePlayLog(players: Set<string>, winners: Set<string>, game: Game): Promise<Writeable> {
    let filename = "data/play_log.txt";
    const playLogBlob = await Octo.info(filename);
    let playLogText = atob(playLogBlob.content);

    const today = new Date();
    const playerArray = Array.from(players).sort(nameSort);
    const winnerArray = Array.from(winners).sort(nameSort);

    const playerList = playerArray.length == 2 ? playerArray.join(" vs ") : "[" + playerArray.join(", ") + "]";

    let winnerList: string = "";
    if (winnerArray.length === playerArray.length) {
        winnerList = "tie";
    } else if (winnerArray.length > 1) {
        winnerList = "[" + winnerArray.join(", ") + "]";
    } else if (winnerArray.length === 1) {
        winnerList = winnerArray[0]
    }
    playLogText += `\n${today}: Game of ${game}. Players: ${playerList}. Winners: ${winnerList}.`;

    return {
        path: filename,
        contents: playLogText,
        sha: playLogBlob.sha,
        message: `Logging game between ${playerList}`,
    }
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

function validatePlayersExist(players: Set<string>, validPlayers: Array<Player>): boolean {
    for (let validatingPlayer of players) {
        let playerFound = false;
        for (let player of validPlayers) {
            if (validatingPlayer === player.username) {
                playerFound = true;
                break;
            }
        }

        if (playerFound === false) {
            const apiError = nonExistentPlayerError(validatingPlayer);
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

function nonExistentPlayerError(playerName: string): ApiError {
    return {
        title: "Player does not exist!",
        message: `The player "${playerName}" does not exist and must be added before any of their games can be recorded.`,
    };
}
