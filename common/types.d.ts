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

export interface GameNext extends Identifiable {
    image?: string;
    name: string;
    hasScores: boolean;
}

// Players

export interface PlayerNext extends Identifiable {
    avatar?: string;
    displayName: string;
    username: string;
}

// Plays

export interface PlayNext extends Identifiable {
    game: number;
    playedOn: string;
    players: number[];
    winners: number[];
    scores?: number[];
}

// Standings

export interface RecordNext {
    wins: number;
    losses: number;
    ties: number;
    isBest?: boolean;
    isWorst?: boolean;
}

export interface PlayerRecordNext {
    scoreStats?: ScoreStatsNext;
    lastPlayed?: string;
    overallRecord: RecordNext;
    records: {
        [key: number]: RecordNext;
    };
}

export interface ScoreStatsNext {
    best: number;
    worst: number;
    average: number;
    gamesPlayed: number;
}

export interface GameRecordNext {
    scoreStats?: ScoreStatsNext;
    records: {
        [key: number]: PlayerRecordNext;
    };
}

// GraphQL

export interface GameGQL extends GameNext {
    standings: GameRecordGQL;
    recentPlays: PlayGQL[];
}

export interface PlayerGQLNext extends PlayerNext {
    records: PlayerGameRecordGQL[];
    recentPlays: PlayGQL[];
}

export interface PlayGQL extends Identifiable {
    game: GameNext;
    playedOn: string;
    players: PlayerNext[];
    winners: PlayerNext[];
    scores?: number[];
}

export interface PlayerRecordGQL {
    player: PlayerNext;
    record: PlayerGameRecordGQL;
}

export interface GameRecordGQL {
    scoreStats?: ScoreStatsNext;
    records: PlayerRecordGQL[];
}

export interface PlayerGameRecordGQL {
    game: GameNext;
    scoreStats?: ScoreStatsNext;
    lastPlayed?: string;
    overallRecord: RecordNext;
    records: PlayerRecordVSGQL[];
}

export interface PlayerRecordVSGQL {
    opponent: PlayerNext;
    record: RecordNext;
}
