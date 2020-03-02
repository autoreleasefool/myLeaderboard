import {
    GraphQLObjectType,
    GraphQLNonNull,
} from 'graphql';

import record from './record';
import playerBasic from './playerBasic';

export default new GraphQLObjectType<void, void, {}>({
    name: 'PlayerVSRecord',
    description: 'Player record against another player',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        player: {
            type: GraphQLNonNull(playerBasic),
        },
        record: {
            type: GraphQLNonNull(record),
        },
    }),
});
