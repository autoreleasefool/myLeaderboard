import { buildSchema } from 'graphql';

const schema = buildSchema(`
    scalar DateTime,

    type Query {
        players(first: Int, offset: Int): [Player!]!
        playerRecord(id: Int!, game: Int!): PlayerStandings
        games(first: Int, offset: Int): [Game!]!
        gameStandings(id: Int!): GameStandings
        plays(first: Int, offset: Int): [Play!]!
        hasAnyUpdates(since: DateTime): Boolean!
    },

    type Mutation {
        createGame(name: String!, hasScores: Boolean!): Game
        createPlayer(name: String!, username: String!): Player
        recordPlay(players: [Int!]!, winners: [Int!]!, scores: [Int!], game: Int!): Play
    },

    type Player {
        id: Int!
        displayName: String!
        username: String!
        avatar: String
    },

    type Game {
        id: Int!
        name: String!
        hasScores: Boolean!
        image: String
    },

    type Play {
        game: Int!
        playedOn: String!
        players: [Int!]!
        winners: [Int!]!
        scores: [Int!]
    },

    type Record {
        wins: Int!
        losses: Int!
        ties: Int!
        isBest: Boolean
        isWorst: Boolean
    },

    type ScoreStats {
        best: Int!
        worst: Int!
        average: Int!
        gamesPlayed: Int!
    },

    type PlayerRecord {
        lastPlayed: String!
        overallRecord: Record!
        scoreStats: ScoreStats
    },

    type GameStandings {
        scoreStats: ScoreStats
    },

    type PlayerStandings {
        scoreStats: ScoreStats
        overallRecord: Record!
    }
`);

export default schema;
