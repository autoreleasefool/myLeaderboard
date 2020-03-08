import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLBoolean,
    GraphQLID,
} from 'graphql';
import { GameNext } from '../../lib/types';
import { SchemaContext} from '../schema';

export default new GraphQLObjectType<GameNext, SchemaContext, {}>({
    name: 'BasicGame',
    description: 'Game from the MyLeaderboard API',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
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
    }),
});
