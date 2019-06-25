export interface Blob {
    content: string;
    encoding: string;
    path: string;
    sha: string;
}

export interface User {
    login: string;
    avatarUrl: string;
    name: string;
}

export interface Author {
    date: string;
    name: string;
    email: string;
}

export interface CommitSha {
    url: string;
    sha: string;
}

export interface Commit {
    sha: string;
    url: string;
    message: string;
    author: Author;
    committer: Author;
    tree: CommitSha;
    parents: Array<CommitSha>;
}

export interface RepositoryCommits {
    items: [Commit];
}