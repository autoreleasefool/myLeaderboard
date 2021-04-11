import * as Octokat from 'octokat';
import { base64decode, base64encode } from './Base64';
import { GitHubUser } from '../lib/types';
import fs from 'fs';

export interface Blob {
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

export interface Writeable {
    path: string;
    sha?: string;
    content: string;
    message?: string;
}

class Octo {
    public static setToken(token: string | undefined): void {
        Octo.token = token;
        Octo.instance = undefined;
    }

    public static setBranch(branch: string): void {
        Octo.branch = branch;
    }

    public static setUseLocal(useLocal: boolean): void {
        Octo.useLocal = useLocal;
    }

    public static getInstance(): Octo {
        if (Octo.instance == null) {
            Octo.instance = new Octo(Octo.token);
        }

        return Octo.instance;
    }

    private static instance: Octo | undefined;
    private static branch = 'main';
    private static token: string | undefined;
    private static useLocal = false;

    private octo: any;
    private repo: any;

    private constructor(token: string | undefined) {
        this.octo = Octokat.default({ token });
        this.repo = this.octo.repos('autoreleasefool', 'myLeaderboard');
    }

    // Users

    public async user(name: string): Promise<GitHubUser> {
        if (name.charAt(0) === '@') {
            name = name.substr(1);
        }

        return await this.octo.users(name).fetch();
    }

    // Contents

    public async contents(filename: string): Promise<string> {
        if (Octo.useLocal) {
            return fs.readFileSync(`../${filename}`, 'utf8').toString();
        } else {
            return await this.repo.contents(filename).read({ ref: Octo.branch });
        }
    }

    public async blob(filename: string): Promise<Blob> {
        if (Octo.useLocal) {
            return {
                path: filename,
                content: fs.readFileSync(`../${filename}`, 'utf8').toString(),
                sha: '',
            };
        } else {
            const contents = await this.repo.contents(filename).fetch({ ref: Octo.branch });
            contents.content = base64decode(contents.content);
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
            const message = writeable.message != null ? writeable.message : `Updating ${writeable.path}`;
            if (Octo.useLocal) {
                console.log(`Writing to ${writeable.path}, "${message}"`)
                return fs.writeFileSync(`../${writeable.path}`, writeable.content);
            } else {
                await this.repo.contents(writeable.path)
                    .add({
                        content: base64encode(writeable.content),
                        sha: writeable.sha,
                        message,
                    });
            }
        }
    }
}

export default Octo;
