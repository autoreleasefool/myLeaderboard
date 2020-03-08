import Octo from '../common/Octo';
import { PlayerNext } from '../lib/types';
import Table, { ListArguments } from './table';

class Players extends Table<PlayerNext> {
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

    public isUsernameTaken(username: string): boolean {
        for (const player of this.all({first: -1, offset: 0})) {
            if (player.username === username) {
                return true;
            }
        }

        return false;
    }

    public async findByIdWithAvatar(id: number): Promise<PlayerNext | undefined> {
        const player = this.findById(id);
        return player ? this.addAvatar(player) : undefined;
    }

    public async allWithAvatars(args: ListArguments): Promise<Array<PlayerNext>> {
        const rows = this.all(args);
        return Promise.all(rows.map(player => this.addAvatar(player)));
    }

    public async allByIdsWithAvatars(ids: readonly number[]): Promise<Array<PlayerNext>> {
        const rows = this.allByIds(ids);
        return Promise.all(rows.map(player => this.addAvatar(player)));
    }

    private async addAvatar(player: PlayerNext): Promise<PlayerNext> {
        const user = await Octo.getInstance().user(player.username);
        return {
            ...player,
            avatar: user.avatarUrl,
        };
    }
}

export default Players;
