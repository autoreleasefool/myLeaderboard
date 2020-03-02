import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLID,
} from 'graphql';
import { Player } from '../../lib/types';

export default new GraphQLObjectType<Player, void, {}>({
    name: 'BasicPlayer',
    description: 'Player from the MyLeaderboard API',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
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
