import { getParam } from "./utils";
import * as Octokat from "./octokat.js";

interface Blob {
    content: string;
    encoding: string;
    path: string;
    sha: string;
}

interface User {
    login: string;
    avatarUrl: string;
    name: string;
}

interface Author {
    name: string;
    email: string;
    date: string;
}

interface CommitDetails {
    author: Author;
    committer: Author;
    message: string;
}

interface Commit {
    sha: string;
    commit: CommitDetails;
}

export interface Writeable {
    path: string;
    sha: string;
    contents: string;
    message?: string;
}

export class Octo {
    private static instance: Octo;

    private octo: any;
    private repo: any;

    private constructor() {
        const token = getParam("token");

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

    // Repo

    public static async commits(since?: Date): Promise<Array<CommitDetails>> {
        const commitInfo = (since == null) ?
            await Octo.getInstance().repo.commits.fetch()
            : await Octo.getInstance().repo.commits.fetch({ since: since.toISOString() });
        const commits: Array<Commit> = commitInfo.items;

        let commitDetails: Array<CommitDetails> = [];
        for (let commit of commits) {
            commitDetails.push(commit.commit);
        }
        return commitDetails;
    }

    // Users

    public static user(name: string): Promise<User> {
        if (name.charAt(0) === "@") {
            name = name.substr(1);
        }
        return Octo.getInstance().octo.users(name).fetch();
    }

    // File Contents

    public static contents(path: string): Promise<string> {
        return Octo.getInstance().repo.contents(path).read();
    }

    public static info(path: string): Promise<Blob> {
        return Octo.getInstance().repo.contents(path).fetch();
    }

    // Writing

    public static async write(writeables: Array<Writeable>): Promise<void> {
        for (let writeable of writeables) {
            await Octo.getInstance().repo
                .contents(writeable.path)
                .add({
                    message: (writeable.message != null) ? writeable.message : `Updating ${writeable.path}`,
                    content: btoa(writeable.contents),
                    sha: writeable.sha,
                });
        }
    }
}
