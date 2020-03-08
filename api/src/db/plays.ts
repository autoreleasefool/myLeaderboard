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

    public allByPlayerId(playerId: number, {first, offset}: ListArguments): Array<PlayNext> {
        let skipCount = 0;
        const result: Array<PlayNext> = [];
        const plays = this.all({first: -1, offset: 0});
        for (let i = plays.length - 1; i >= 0 && result.length < first; i--) {
            if (plays[i].players.indexOf(playerId) >= 0) {
                if (skipCount < offset) {
                    skipCount += 1;
                } else {
                    result.push(plays[i]);
                }
            }
        }
        return result;
    }

    public allByGameId(gameId: number, {first, offset}: ListArguments): Array<PlayNext> {
        let skipCount = 0;
        const result: Array<PlayNext> = [];
        const plays = this.all({first: -1, offset: 0});
        for (let i = plays.length - 1; i >= 0 && result.length < first; i--) {
            if (plays[i].game === gameId) {
                if (skipCount < offset) {
                    skipCount += 1;
                } else {
                    result.push(plays[i]);
                }
            }
        }
        return result;
    }
}

export default Plays;
