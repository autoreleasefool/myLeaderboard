import Octo from '../common/Octo';
import { Player } from '../lib/types';
import Table, { ListArguments } from './table';

class Players extends Table<Player> {
    public static getInstance(): Players {
        if (Players.instance == null) {
            Players.instance = new Players();
        }

        return Players.instance;
    }

    private static instance: Players | undefined;

    private constructor() {
        super('players');
    }

    public isUsernameTaken(username: string, board: number): boolean {
        for (const player of this.all({first: -1, offset: 0, filter: player => player.board === board})) {
            if (player.username === username) {
                return true;
            }
        }

        return false;
    }

    public async findByIdWithAvatar(id: number): Promise<Player | undefined> {
        const player = this.findById(id);
        return player ? this.addAvatar(player) : undefined;
    }

    public async allWithAvatars(args: ListArguments<Player>): Promise<Array<Player>> {
        const rows = this.all(args);
        return Promise.all(rows.map(player => this.addAvatar(player)));
    }

    public async allByIdsWithAvatars(ids: readonly number[]): Promise<Array<Player>> {
        const rows = this.allByIds(ids);
        return Promise.all(rows.map(player => this.addAvatar(player)));
    }

    private async addAvatar(player: Player): Promise<Player> {
        const user = await Octo.getInstance().user(player.username);
        return {
            ...player,
            avatar: user.avatarUrl,
        };
    }
}

export default Players;
