import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLID,
    GraphQLList,
    GraphQLInt,
} from 'graphql';
import game from './game';
import player from './player';

export default new GraphQLObjectType({
    name: 'Play',
    description: 'Play from the MyLeaderboard API',
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
        },
        playedOn: {
            type: GraphQLNonNull(GraphQLString),
        },
        scores: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(GraphQLInt))),
        },
        game: {
            type: GraphQLNonNull(game),
            resolve: async (play, _, {loader}) => loader.gameLoader.load(play.game),
        },
        players: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(player))),
            resolve: async (play, _, {loader}) => loader.playerLoader.loadMany(play.players),
        },
        winners: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(player))),
            resolve: async (play, _, {loader}) => loader.playerLoader.loadMany(play.winners),
        },
    }),
});
