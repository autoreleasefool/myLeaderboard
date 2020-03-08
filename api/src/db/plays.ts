import { PlayNext } from '../lib/types';
import Table, { ListArguments } from './table';

class Plays extends Table<PlayNext> {
    public static getInstance(): Plays {
        if (Plays.instance == null) {
            Plays.instance = new Plays();
        }

        return Plays.instance;
    }

    private static instance: Plays | undefined;

    private constructor() {
        super('plays');
    }
}

export default Plays;
