import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLInt,
    GraphQLFloat,
} from 'graphql';

export default new GraphQLObjectType<void, void, {}>({
    name: 'ScoreStats',
    description: 'Score statistics for a given game or player.',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        best: {
            type: GraphQLNonNull(GraphQLInt),
            description: 'All time best score.',
        },
        worst: {
            type: GraphQLNonNull(GraphQLInt),
            description: 'All time worst score.',
        },
        average: {
            type: GraphQLNonNull(GraphQLFloat),
            description: 'All time average score.',
        },
        gamesPlayed: {
            type: GraphQLNonNull(GraphQLInt),
            description: 'Total number of games played.',
        },
    }),
});
