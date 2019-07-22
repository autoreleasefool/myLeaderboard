import { Game } from '../lib/types';
import Table from './table';

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
}

export default Games;
