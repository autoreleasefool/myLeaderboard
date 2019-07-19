declare module 'octokat';
declare module 'dotenv';

// Games

export interface Game {
    id: number;
    name: string;
    hasScores: boolean;
}

// Players

export interface Player {
    avatar?: string;
    displayName: string;
    id: number;
    username: string;
}

export interface GitHubUser {
    login: string;
    avatarUrl: string;
}

// Plays

export interface Play {
    id: number;
    game: number;
    playedOn: string;
    players: Array<number>;
    winners: Array<number>;
    scores?: Array<number>;
}

// Standings

export interface Record {
    wins: number;
    losses: number;
    ties: number;
    isBest?: boolean;
    isWorst?: boolean;
}
