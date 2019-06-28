import { getParam } from './Params';
import * as Octokat from 'octokat';

export interface Player {
    username: string;
    displayName: string;
    lastPlayed: Date;
    avatar: string;
}

interface Blob {
    content: string;
    encoding: string;
    path: string;
    sha: string;
}

interface BasicPlayer {
    username: string;
    displayName: string;
    lastPlayed: string;
}

interface GitHubUser {
    login: string;
    avatarUrl: string;
    name: string;
}

class Octo {
    private static instance: Octo;

    private octo: any;
    private repo: any;
    private userCache: Map<string, GitHubUser> = new Map();
    private contentsCache: Map<string, string> = new Map();

    private constructor() {
        const token = getParam('token');

        // @ts-ignore Octokat isn't playing nice with TS, so ignore the error that it's not a constructor.
        this.octo = new Octokat({ token });
        this.repo = this.octo.repos("josephroquedev", "myLeaderboard");
    }

    public static getInstance(): Octo {
        if (Octo.instance == null) {
            Octo.instance = new Octo();
        }

        return Octo.instance;
    }

    clearCache() {
        this.userCache.clear();
        this.contentsCache.clear();
    }

    // Users

    async players(): Promise<Array<Player>> {
        const contents = await this.contents("players.json");
        const basicPlayers: Array<BasicPlayer> = JSON.parse(contents);

        let promises: Array<Promise<GitHubUser>> = [];
        for (let basicPlayer of basicPlayers) {
            promises.push(this.user(basicPlayer.username));
        }

        let users = await Promise.all(promises);

        let players: Array<Player> = [];
        for (let i = 0; i < basicPlayers.length; i++) {
            players.push({
                username: basicPlayers[i].username,
                displayName: basicPlayers[i].displayName,
                lastPlayed: new Date(basicPlayers[i].lastPlayed),
                avatar: users[i].avatarUrl,
            });
        }
        return players;
    }

    async user(name: string): Promise<GitHubUser> {
        if (name.charAt(0) === "@") {
            name = name.substr(1);
        }

        let user: GitHubUser;
        if (this.userCache.has(name)) {
            user = this.userCache.get(name)!;
        } else {
            user = await this.octo.users(name).fetch();
            this.userCache.set(name, user);
        }

        return user;
    }

    // Contents

    async contents(filename: string): Promise<string> {
        if (this.contentsCache.has(filename)) {
            return this.contentsCache.get(filename)!;
        } else {
            let contents = await this.repo.contents(filename).read();
            this.contentsCache.set(filename, contents);
            return contents;
        }
    }
}

export default Octo;
