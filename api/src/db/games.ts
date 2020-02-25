import { Game } from '../lib/types';
import Table from './table';
import { apiURL } from '../common/utils';

class Games extends Table<Game> {
    public static getInstance(): Games {
        if (Games.instance == null) {
            Games.instance = new Games();
        }

        return Games.instance;
    }

    private static instance: Games | undefined;

    private constructor() {
        super('games');
    }

    public allWithImages(): Array<Game> {
        const gameList = this.all();
        for (const game of gameList) {
            game.image = `${apiURL(true)}/img/games/${game.name}.png`;
        }
        return gameList;
    }
}

export default Games;
