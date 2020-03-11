import {
    GraphQLObjectType,
    GraphQLNonNull,
} from 'graphql';

import record from './record';
import playerBasic from './playerBasic';

export default new GraphQLObjectType<void, void, {}>({
    name: 'PlayerVSRecord',
    description: 'Player record against another player.',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        opponent: {
            type: GraphQLNonNull(playerBasic),
            description: 'Player the record is against.',
        },
        record: {
            type: GraphQLNonNull(record),
            description: 'Record against the opponent.',
        },
    }),
});
