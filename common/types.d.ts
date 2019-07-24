declare module 'octokat';
declare module 'dotenv';
declare module 'fs';

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

export interface Record {
    wins: number;
    losses: number;
    ties: number;
    isBest?: boolean;
    isWorst?: boolean;
}

export interface VsRecord {
    [key: number]: Record;
}

export interface PlayerRecord {
    scoreStats?: ScoreStats;
    lastPlayed: string;
    overallRecord: Record;
    record: VsRecord;
}

export interface ScoreStats {
    best: number;
    worst: number;
    average: number;
    gamesPlayed: number;
}

export interface GameStandings {
    scoreStats?: ScoreStats;
    records: {
        [key: number]: PlayerRecord;
    };
}

export interface PlayerStandings extends VsRecord {
    scoreStats?: ScoreStats;
    overallRecord: Record;
}
