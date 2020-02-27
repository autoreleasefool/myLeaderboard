import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLID,
} from 'graphql';

export default new GraphQLObjectType({
    name: 'Player',
    description: 'Player from the MyLeaderboard API',
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
        },
        username: {
            type: GraphQLNonNull(GraphQLString),
        },
        displayName: {
            type: GraphQLNonNull(GraphQLString),
        },
        avatar: {
            type: GraphQLString,
        },
    }),
});
