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

    public async findByIdWithAvatar(id: number): Promise<Player | undefined> {
        const player = this.findById(id);
        return player ? this.addAvatar(player) : undefined;
    }

    public async allWithAvatars(args: ListArguments): Promise<Array<Player>> {
        const rows = this.all(args);
        return Promise.all(rows.map(player => this.addAvatar(player)));
    }

    private async addAvatar(player: Player): Promise<Player> {
        let user = await Octo.getInstance().user(player.username);
        return {
            ...player,
            avatar: user.avatarUrl,
        }
    }
}

export default Players;
