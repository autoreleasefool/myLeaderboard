import { buildSchema } from 'graphql';

const schema = buildSchema(`
    scalar DateTime,

    type Query {
        player(id: ID!): Player
        players(first: Int, offset: Int): [Player!]!
        playerRecord(id: ID!, game: ID!): PlayerStandings
        game(id: ID!): Game
        games(first: Int, offset: Int): [Game!]!
        gameStandings(id: ID!): GameStandings
        play(id: ID!): Play
        plays(first: Int, offset: Int): [Play!]!
        hasAnyUpdates(since: DateTime): Boolean!
    },

    type Mutation {
        createGame(name: String!, hasScores: Boolean!): Game
        createPlayer(name: String!, username: String!): Player
        recordPlay(players: [ID!]!, winners: [ID!]!, scores: [Int!], game: ID!): Play
    },

    type Player {
        id: ID!
        displayName: String!
        username: String!
        avatar: String
    },

    type Game {
        id: ID!
        name: String!
        hasScores: Boolean!
        image: String
    },

    type Play {
        id: ID!
        game: Game!
        playedOn: String!
        players: [Player!]!
        winners: [Player!]!
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
        records: [PlayerVSRecord!]!
    },

    type PlayerVSRecord {
        player: Player!
        record: Record!
    }

    type GameStandings {
        scoreStats: ScoreStats
        records: [GamePlayerRecord!]!
    },

    type GamePlayerRecord {
        player: Player!
        record: PlayerRecord!
    }

    type PlayerStandings {
        scoreStats: ScoreStats
        overallRecord: Record!
        records: [PlayerVSRecord!]!
    }
`);

export default schema;
