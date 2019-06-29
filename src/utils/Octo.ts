import * as Octokat from 'octokat';
import { getParam } from './Params';

export interface Player {
    username: string;
    displayName: string;
    lastPlayed: Date;
    avatar: string;
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

interface Author {
    name: string;
    email: string;
    date: string;
}

interface Commit {
    author: Author;
    committer: Author;
    message: string;
}

interface CommitItem {
    sha: string;
    commit: Commit;
}

interface Writeable {
    path: string;
    sha: string;
    contents: string;
    message?: string;
}

class Octo {
    public static getInstance(): Octo {
        if (Octo.instance == null) {
            Octo.instance = new Octo();
        }

        return Octo.instance;
    }

    private static instance: Octo;

    private octo: any;
    private repo: any;
    private userCache: Map<string, GitHubUser> = new Map();
    private contentsCache: Map<string, string> = new Map();

    private constructor() {
        const token = getParam('token');

        // @ts-ignore Octokat isn't playing nice with TS, so ignore the error that it's not a constructor.
        this.octo = new Octokat({ token });
        this.repo = this.octo.repos('josephroquedev', 'myLeaderboard');
    }

    public clearCache() {
        this.userCache.clear();
        this.contentsCache.clear();
    }

    // Users

    public async players(): Promise<Array<Player>> {
        const contents = await this.contents('players.json');
        const basicPlayers: Array<BasicPlayer> = JSON.parse(contents);

        const promises: Array<Promise<GitHubUser>> = [];
        for (const basicPlayer of basicPlayers) {
            promises.push(this.user(basicPlayer.username));
        }

        const users = await Promise.all(promises);

        const players: Array<Player> = [];
        for (let i = 0; i < basicPlayers.length; i++) {
            players.push({
                avatar: users[i].avatarUrl,
                displayName: basicPlayers[i].displayName,
                lastPlayed: new Date(basicPlayers[i].lastPlayed),
                username: basicPlayers[i].username,
            });
        }
        return players;
    }

    public async user(name: string): Promise<GitHubUser> {
        if (name.charAt(0) === '@') {
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

    public async contents(filename: string): Promise<string> {
        if (this.contentsCache.has(filename)) {
            return this.contentsCache.get(filename)!;
        } else {
            const contents = await this.repo.contents(filename).read();
            this.contentsCache.set(filename, contents);
            return contents;
        }
    }

    // Repo

    public async commits(since?: Date): Promise<Array<Commit>> {
        const commitInfo = (since == null)
            ? await this.repo.commits.fetch()
            : await this.repo.commits.fetch({ since: since.toISOString() });

        const commitItems: Array<CommitItem> = commitInfo.items;
        const commits: Array<Commit> = [];
        for (const commit of commitItems) {
            commits.push(commit.commit);
        }
        return commits;
    }

    public async write(writeables: Array<Writeable>): Promise<void> {
        for (const writeable of writeables) {
            await this.repo.contents(writeable.path)
                .add({
                    content: btoa(writeable.contents),
                    message: (writeable.message != null) ? writeable.message : `Updating ${writeable.path}`,
                    sha: writeable.sha,
                });
        }
    }
}

export default Octo;
