import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLInt,
    GraphQLFloat,
} from 'graphql';

export default new GraphQLObjectType<void, void, {}>({
    name: 'ScoreStats',
    description: 'Score statistics for a given game',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        best: {
            type: GraphQLNonNull(GraphQLInt),
        },
        worst: {
            type: GraphQLNonNull(GraphQLInt),
        },
        average: {
            type: GraphQLNonNull(GraphQLFloat),
        },
        gamesPlayed: {
            type: GraphQLNonNull(GraphQLInt),
        },
    }),
});
