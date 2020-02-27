import {
    GraphQLObjectType,
    GraphQLNonNull,
} from 'graphql';

import player from './player';
import record from './record';

export default new GraphQLObjectType({
    name: 'PlayerVSRecord',
    description: 'Player record against another player',
    fields: () => ({
        player: {
            type: GraphQLNonNull(player),
        },
        record: {
            type: GraphQLNonNull(record),
        },
    }),
});
