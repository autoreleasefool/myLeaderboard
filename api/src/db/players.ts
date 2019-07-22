import Octo from '../lib/Octo';
import { GitHubUser, Player } from '../lib/types';
import Table from './table';

class Players extends Table<Player> {
    private static instance: Players | undefined;

    private constructor() {
        super('players');
    }

    public getInstance(): Players {
        if (Players.instance == null) {
            Players.instance = new Players();
        }

        return Players.instance;
    }

    public async allWithAvatars(): Promise<Array<Player>> {
        const rows = this.all();

        const gitHubDetailsPromises: Array<Promise<GitHubUser>> = [];
        for (const player of rows) {
            gitHubDetailsPromises.push(Octo.getInstance().user(player.username));
        }

        const gitHubUsers = await Promise.all(gitHubDetailsPromises);

        for (const player of rows) {
            for (const user of gitHubUsers) {
                if (user.login === player.username) {
                    player.avatar = user.avatarUrl;
                }
            }
        }

        return rows;
    }
}

export default Players;
