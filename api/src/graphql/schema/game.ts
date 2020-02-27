import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLBoolean,
    GraphQLID,
} from 'graphql';

export default new GraphQLObjectType({
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
    }),
});
