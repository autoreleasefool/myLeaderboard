declare module 'octokat';
declare module 'dotenv';

// Players

export interface BasicPlayer {
    displayName: string;
    username: string;
}

export interface BasicGamePlayer extends BasicPlayer {
    lastPlayed: string;
}

export interface GitHubUser {
    login: string;
    avatarUrl: string;
}

export interface GenericPlayer {
    avatar: string;
    displayName: string;
    username: string;
}

export interface Player extends GenericPlayer {
    lastPlayed: Date;
}

// Standings

export interface Record {
    wins: number;
    losses: number;
    ties: number;
    isBest?: boolean;
    isWorst?: boolean;
}

export interface VsRecord {
    [key: string]: Record;
}

export interface GameStandings {
    players: Array<BasicGamePlayer>;
    records: {
        [key: string]: VsRecord;
    };
}
