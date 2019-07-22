import { Game } from '../lib/types';
import Table from './table';

class Games extends Table<Game> {
    private static instance: Games | undefined;

    private constructor() {
        super('games');
    }

    public getInstance(): Games {
        if (Games.instance == null) {
            Games.instance = new Games();
        }

        return Games.instance;
    }
}

export default Games;
