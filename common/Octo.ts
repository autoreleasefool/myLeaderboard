// @ts-ignore: Common module in api/dashboard
import * as Octokat from 'octokat';
// @ts-ignore: Common module in api/dashboard
import { base64decode, base64encode } from '../common/Base64';
import { allGames } from './Game';
import { BasicPlayer, BasicGamePlayer, GameStandings, GitHubUser, GenericPlayer } from './types';

interface Blob {
    content: string;
    path: string;
    sha: string;
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

interface Content {
    type: string;
    name: string;
}

export interface Writeable {
    path: string;
    sha?: string;
    content: string;
    message?: string;
}

class Octo {
    public static setToken(token: string | undefined) {
        Octo.token = token;
        Octo.instance = undefined;
    }

    public static setBranch(branch: string) {
        Octo.branch = branch;
    }

    public static getInstance(): Octo {
        if (Octo.instance == null) {
            Octo.instance = new Octo(Octo.token);
        }

        return Octo.instance;
    }

    private static instance: Octo | undefined;
    private static branch: string = 'master';
    private static token: string | undefined;

    private octo: any;
    private repo: any;
    private userCache: Map<string, GitHubUser> = new Map(); // TODO: store promises while waiting for response
    private dirCache: Map<string, Array<Content>> = new Map(); // TODO: store promises while waiting for response
    private contentsCache: Map<string, string> = new Map(); // TODO: store promises while waiting for response
    private blobCache: Map<string, Blob> = new Map(); // TODO: store promises while waiting for response

    private constructor(token: string | undefined) {
        // @ts-ignore Octokat isn't playing nice with TS, so ignore the error that it's not a constructor.
        this.octo = Octokat.default({ token });
        this.repo = this.octo.repos('josephroquedev', 'myLeaderboard');
    }

    public clearCache() {
        this.userCache.clear();
        this.contentsCache.clear();
        this.blobCache.clear();
    }

    // Users

    public async players(forGame: string | undefined = undefined): Promise<Array<GenericPlayer>> {
        const playerUsernames: Set<string> = new Set();
        const basicPlayers: Array<BasicPlayer> = [];

        let games: Array<string>;
        if (forGame == undefined) {
            games = await allGames();
        } else {
            games = [forGame];
        }

        for (const game of games) {
            const gamePlayers = await this.playersForGame(game);
            for (const gamePlayer of gamePlayers) {
                if (playerUsernames.has(gamePlayer.username) === false) {
                    playerUsernames.add(gamePlayer.username);
                    basicPlayers.push(gamePlayer);
                }
            }
        }

        const promises: Array<Promise<GitHubUser>> = [];
        for (const basicPlayer of basicPlayers) {
            promises.push(this.user(basicPlayer.username));
        }

        const users = await Promise.all(promises);

        const players: Array<GenericPlayer> = [];
        for (let i = 0; i < basicPlayers.length; i++) {
            players.push({
                avatar: users[i].avatarUrl,
                displayName: basicPlayers[i].displayName,
                username: basicPlayers[i].username,
            });
        }
        return players;
    }

    private async playersForGame(game: string): Promise<Array<BasicGamePlayer>> {
        const contents = await this.contents(`data/${game}.json`);
        const standings: GameStandings = JSON.parse(contents);
        return standings.players;
    }

    public async user(name: string): Promise<GitHubUser> {
        if (name.charAt(0) === '@') {
            name = name.substr(1);
        }

        if (this.userCache.has(name)) {
            return this.userCache.get(name)!;
        } else {
            const user = await this.octo.users(name).fetch();
            this.userCache.set(name, user);
            return user;
        }
    }

    // Contents

    public async dir(path: string): Promise<Array<Content>> {
        let contents: Array<Content> | undefined = this.dirCache.get(path);
        if (contents == null) {
            const dirContents = await this.repo.contents(path).read({ ref: Octo.branch });
            this.dirCache.set(path, dirContents.items);
            contents = dirContents.items;
        }

        return contents!;
    }

    public async contents(filename: string): Promise<string> {
        if (this.contentsCache.has(filename)) {
            return this.contentsCache.get(filename)!;
        } else {
            const contents = await this.repo.contents(filename).read({ ref: Octo.branch });
            this.contentsCache.set(filename, contents);
            return contents;
        }
    }

    public async blob(filename: string): Promise<Blob> {
        if (this.blobCache.has(filename)) {
            return this.blobCache.get(filename)!;
        } else {
            const contents = await this.repo.contents(filename).fetch();
            contents.content = base64decode(contents.content);
            this.blobCache.set(filename, contents);
            return contents;
        }
    }

    // Repo

    public async commits(since?: Date): Promise<Array<Commit>> {
        const commitInfo = (since == null)
            ? await this.repo.commits.fetch({ sha: Octo.branch })
            : await this.repo.commits.fetch({ since: since.toISOString(), sha: Octo.branch });

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
                    content: base64encode(writeable.content),
                    message: (writeable.message != null) ? writeable.message : `Updating ${writeable.path}`,
                    sha: writeable.sha,
                });
        }
    }
}

export default Octo;