import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLInt,
    GraphQLBoolean,
} from 'graphql';

export default new GraphQLObjectType<void, void, {}>({
    name: 'Record',
    description: 'Win/Loss record.',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        wins: {
            type: GraphQLNonNull(GraphQLInt),
            description: 'Number of wins.',
        },
        losses: {
            type: GraphQLNonNull(GraphQLInt),
            description: 'Number of losses.',
        },
        ties: {
            type: GraphQLNonNull(GraphQLInt),
            description: 'Number of ties.',
        },
        isBest: {
            type: GraphQLBoolean,
            description: 'True if this represents the best record relative to similar records (of the player or the game).',
        },
        isWorst: {
            type: GraphQLBoolean,
            description: 'True if this represents the worst record relative to similar records (of the player or the game).',
        },
    }),
});
