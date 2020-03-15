import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLID,
} from 'graphql';
import { Player } from '../../lib/types';

export default new GraphQLObjectType<Player, void, {}>({
    name: 'BasicPlayer',
    description: 'Player from the MyLeaderboard API.',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
            description: 'Unique ID.',
        },
        username: {
            type: GraphQLNonNull(GraphQLString),
            description: 'GitHub username of the player.',
        },
        displayName: {
            type: GraphQLNonNull(GraphQLString),
            description: 'Display name of the player.',
        },
        avatar: {
            type: GraphQLString,
            description: 'Avatar of the player.',
        },
    }),
});
