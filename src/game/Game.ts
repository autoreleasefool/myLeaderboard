export enum Game {
    Hive = "Hive",
    Patchwork = "Patchwork",
}

export function allGames(): Array<Game> {
    let games: Array<Game> = [];
    for (const game in Game) {
        games.push(game as Game);
    }

    return games;
}
