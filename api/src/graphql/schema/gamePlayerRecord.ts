import {
    GraphQLObjectType,
    GraphQLNonNull,
} from 'graphql';

import playerRecord from './playerRecord';
import player from './player';

export default new GraphQLObjectType({
    name: 'GamePlayerRecord',
    description: 'Player record for a game',
    fields: () => ({
        player: {
            type: GraphQLNonNull(player),
        },
        record: {
            type: GraphQLNonNull(playerRecord),
        },
    }),
});
