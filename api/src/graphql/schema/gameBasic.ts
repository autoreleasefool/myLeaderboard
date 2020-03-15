import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLBoolean,
    GraphQLID,
} from 'graphql';
import { Game } from '../../lib/types';
import { SchemaContext} from '../schema';

export default new GraphQLObjectType<Game, SchemaContext, {}>({
    name: 'BasicGame',
    description: 'Game from the MyLeaderboard API.',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
            description: 'Unique ID.',
        },
        name: {
            type: GraphQLNonNull(GraphQLString),
            description: 'Name of the game.',
        },
        hasScores: {
            type: GraphQLNonNull(GraphQLBoolean),
            description: 'Indicates if the game includes score keeping.',
        },
        image: {
            type: GraphQLString,
            description: 'Image for the game.',
        },
    }),
});
