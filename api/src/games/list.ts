import { apiURL } from '../common/utils';
import Games from '../db/games';
import { Game } from '../lib/types';

export default async function list(): Promise<Array<Game>> {
    // Input validation
    const gameList = Games.getInstance().all();
    for (const game of gameList) {
        game.image = `${apiURL(true)}/img/games/${game.name}.png`;
    }
    return gameList;
}
