import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLBoolean,
    GraphQLID,
} from 'graphql';
import gameStandings, { gameStandingsToGraphQL } from './gameStandings';
import { gameStandings as generateGameStandings } from '../../games/standings';
import { Game } from '../../lib/types';
import { SchemaContext} from '../schema';

export default new GraphQLObjectType<Game, SchemaContext, {}>({
    name: 'Game',
    description: 'Game from the MyLeaderboard API',
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
        },
        name: {
            type: GraphQLNonNull(GraphQLString),
        },
        hasScores: {
            type: GraphQLNonNull(GraphQLBoolean),
        },
        image: {
            type: GraphQLString,
        },
        standings: {
            type: GraphQLNonNull(gameStandings),
            resolve: async (game, _, {loader}) =>
                gameStandingsToGraphQL(
                    await generateGameStandings(game.id, loader),
                    loader
                ),
        }
    }),
});
