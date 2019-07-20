declare module 'octokat';
declare module 'dotenv';

export interface Identifiable {
    id: number;
}

// Games

export interface Game extends Identifiable {
    image?: string;
    name: string;
    hasScores: boolean;
}

// Players

export interface Player extends Identifiable {
    avatar?: string;
    displayName: string;
    username: string;
}

export interface GitHubUser {
    login: string;
    avatarUrl: string;
}

// Plays

export interface Play extends Identifiable {
    game: number;
    playedOn: string;
    players: Array<number>;
    winners: Array<number>;
    scores?: Array<number>;
}

// Standings

export interface VsRecord {
    [key: string]: Record;
}

export interface Record {
    wins: number;
    losses: number;
    ties: number;
    isBest?: boolean;
    isWorst?: boolean;
}
