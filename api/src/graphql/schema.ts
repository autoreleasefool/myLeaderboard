import { buildSchema } from 'graphql';

const schema = buildSchema(`
    type Query {
        player(id: Int!): Player
        players(first: Int, offset: Int): [Player!]!
        game(id: Int!): Game
        games(first: Int, offset: Int): [Game!]!
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
