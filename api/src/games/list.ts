import Octo from '../lib/Octo';
import { Game } from '../lib/types';

export default async function list(): Promise<Array<Game>> {
    // Input validation
    const gameList = await Octo.getInstance().games();
    for (const game of gameList) {
        game.image = `${process.env.API_URL}/img/games/${game.name}.png`;
    }
    return gameList;
}
