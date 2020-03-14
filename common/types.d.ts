declare module 'octokat';
declare module 'dotenv';
declare module 'fs';

export interface Identifiable {
    id: number;
}

export interface GitHubUser {
    login: string;
    avatarUrl: string;
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

// Plays

export interface Play extends Identifiable {
    game: number;
    playedOn: string;
    players: number[];
    winners: number[];
    scores?: number[];
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
    lastPlayed?: string;
    overallRecord: Record;
    records: {
        [key: string]: Record;
    };
}

export interface ScoreStats {
    best: number;
    worst: number;
    average: number;
    gamesPlayed: number;
}

export interface GameRecord {
    scoreStats?: ScoreStats;
    records: {
        [key: number]: PlayerRecord;
    };
}

// GraphQL

export interface GameGQL extends Game {
    standings: GameRecordGQL;
    recentPlays: PlayGQL[];
}

export interface PlayerGQL extends Player {
    records: PlayerGameRecordGQL[];
    recentPlays: PlayGQL[];
}

export interface PlayGQL extends Identifiable {
    game: Game;
    playedOn: string;
    players: Player[];
    winners: Player[];
    scores?: number[];
}

export interface PlayerRecordGQL {
    player: Player;
    record: PlayerGameRecordGQL;
}

export interface GameRecordGQL {
    scoreStats?: ScoreStats;
    records: PlayerRecordGQL[];
}

export interface PlayerGameRecordGQL {
    game: Game;
    scoreStats?: ScoreStats;
    lastPlayed?: string;
    overallRecord: Record;
    records: PlayerRecordVSGQL[];
}

export interface PlayerRecordVSGQL {
    opponent: Player;
    record: Record;
}
