import {
    GraphQLObjectType,
    GraphQLSchema,
    GraphQLNonNull,
    GraphQLID,
    GraphQLList,
    GraphQLInt
} from 'graphql'

import player from './schema/player';
import game from './schema/game';
import Players from '../db/players';
import Games from '../db/games';
import play from './schema/play';
import Plays from '../db/plays';

let RootQuery = new GraphQLObjectType({
    name: 'Query',
    description: 'Realize Root Query',
    fields: () => ({
        player: {
            type: player,
            args: {
                id: {
                    type: GraphQLNonNull(GraphQLID),
                }
            },
            resolve: async (_, {id}, {loader}) => loader.playerLoader.load(id),
        },

        players: {
            type: GraphQLNonNull(GraphQLList(player)),
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            resolve: async (_, {first, offset}, {loader}) => {
                const players = await Players.getInstance().allWithAvatars({first, offset});
                for (const player of players) {
                    loader.playerLoader.prime(player.id, player);
                }
                return players;
            }
        },

        game: {
            type: game,
            args: {
                id: {
                    type: GraphQLNonNull(GraphQLID),
                }
            },
            resolve: async (_, {id}, {loader}) => loader.gameLoader.load(id),
        },

        games: {
            type: GraphQLNonNull(GraphQLList(game)),
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            resolve: async (_, {first, offset}, {loader}) => {
                const games = await Games.getInstance().allWithImages({first, offset});
                for (const game of games) {
                    loader.gameLoader.prime(game.id, game);
                }
                return games;
            },
        },

        play: {
            type: play,
            args: {
                id: {
                    type: GraphQLID,
                },
            },
            resolve: async (_, {id}, {loader}) => loader.playLoader.load(id),
        },

        plays: {
            type: GraphQLList(GraphQLNonNull(play)),
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            resolve: async (_, {first, offset}, {loader}) => {
                const plays = await Plays.getInstance().all({first, offset});
                for (const play of plays) {
                    loader.playLoader.prime(play.id, play);
                }
                return plays;
            }
        }

        // }
        // players: {
        //     type: GraphQLNonNull(GraphQLList(player)),
        //     args: {
        //         first: GraphQLInt,
        //         offset: GraphQLInt,
        //     },
        //     resolve: async (_, {first, offset}, {rootValue}) => rootValue.loader.playerLoader()
        // }
    }),
});

export default new GraphQLSchema({
    query: RootQuery,
});

// import { buildSchema } from 'graphql';



// const schema = buildSchema(`
//     scalar DateTime,

//     type Query {
//         player(id: ID!): Player
//         players(first: Int, offset: Int): [Player!]!
//         playerRecord(id: ID!, game: ID!): PlayerStandings
//         game(id: ID!): Game
//         games(first: Int, offset: Int): [Game!]!
//         gameStandings(id: ID!): GameStandings
//         play(id: ID!): Play
//         plays(first: Int, offset: Int): [Play!]!
//         hasAnyUpdates(since: DateTime): Boolean!
//     },

//     type Mutation {
//         createGame(name: String!, hasScores: Boolean!): Game
//         createPlayer(name: String!, username: String!): Player
//         recordPlay(players: [ID!]!, winners: [ID!]!, scores: [Int!], game: ID!): Play
//     },
// `);

// export default schema;
