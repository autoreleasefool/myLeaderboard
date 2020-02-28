import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLInt,
} from 'graphql';

export default new GraphQLObjectType<void, void, {}>({
    name: 'ScoreStats',
    description: 'Score statistics for a given game',
    fields: () => ({
        best: {
            type: GraphQLNonNull(GraphQLInt),
        },
        worst: {
            type: GraphQLNonNull(GraphQLInt),
        },
        average: {
            type: GraphQLNonNull(GraphQLInt),
        },
        gamesPlayed: {
            type: GraphQLNonNull(GraphQLInt),
        },
    }),
});
