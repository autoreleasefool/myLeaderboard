import { Play } from '../lib/types';
import Table from './table';

class Plays extends Table<Play> {
    private static instance: Plays | undefined;

    private constructor() {
        super('plays');
    }

    public getInstance(): Plays {
        if (Plays.instance == null) {
            Plays.instance = new Plays();
        }

        return Plays.instance;
    }
}

export default Plays;
