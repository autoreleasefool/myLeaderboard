import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLInt,
    GraphQLBoolean,
} from 'graphql';

export default new GraphQLObjectType<void, void, {}>({
    name: 'Record',
    description: 'Win/Loss record',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        wins: {
            type: GraphQLNonNull(GraphQLInt),
        },
        losses: {
            type: GraphQLNonNull(GraphQLInt),
        },
        ties: {
            type: GraphQLNonNull(GraphQLInt),
        },
        isBest: {
            type: GraphQLBoolean,
        },
        isWorst: {
            type: GraphQLBoolean,
        },
    }),
});
