import { Game } from '../lib/types';
import Table, { ListArguments } from './table';
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

    public findByIdWithImage(id: number): Game | undefined {
        const game = this.findById(id);
        return game ? this.addImage(game) : undefined;
    }

    public allWithImages(args: ListArguments): Array<Game> {
        return this.all(args).map(game => this.addImage(game));
    }

    public allByIdsWithImages(ids: Array<number>): Array<Game> {
        return this.allByIds(ids).map(game => this.addImage(game));
    }

    private addImage(game: Game): Game {
        return {
            ...game,
            image: `${apiURL(true)}/img/games/${game.name}.png`,
        };
    }
}

export default Games;
