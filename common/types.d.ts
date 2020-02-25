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

export interface PlayerRecord {
    scoreStats?: ScoreStats;
    lastPlayed: string;
    overallRecord: Record;
    records: {
        [key: number]: Record;
    };
}

export interface PlayerRecordGraphQL {
    scoreStats?: ScoreStats;
    lastPlayed: string;
    overallRecord: Record;
    records: PlayerVSRecord;
}

export interface PlayerVSRecord {
    opponents: Array<number>;
    records: Array<Record>;
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

export interface GameStandingsGraphQL {
    scoreStats?: ScoreStats;
    records: GamePlayerRecords;
}

export interface GamePlayerRecords {
    players: Array<number>;
    records: Array<PlayerRecordGraphQL>;
}

export interface PlayerStandings {
    scoreStats?: ScoreStats;
    overallRecord: Record;
    records: {
        [key: number]: Record;
    };
}

export interface PlayerStandingsGraphQL {
    scoreStats?: ScoreStats;
    overallRecord: Record;
    records: PlayerVSRecord;
}
