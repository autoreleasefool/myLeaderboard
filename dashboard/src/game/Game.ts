export enum Game {
    Hive = 'Hive',
    Patchwork = 'Patchwork',
}

export function allGames(): Array<Game> {
    const games: Array<Game> = [];
    for (const game in Game) {
        if (Game.hasOwnProperty(game)) {
            games.push(game as Game);
        }
    }

    return games;
}
