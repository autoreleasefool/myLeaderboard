import { allGames, Game } from '../lib/Game';

export default async function list(): Promise<Array<Game>> {
    const gameNames = await allGames();
    const games = gameNames.map(name => {
        return {
            imageURL: `${process.env.API_URL}/img/games/${name}.png`,
            name,
        };
    });

    return games;
}
