import {
    GraphQLObjectType,
    GraphQLNonNull,
} from 'graphql';

import playerGameRecord from './playerGameRecord';
import playerBasic from './playerBasic';

export default new GraphQLObjectType<void, void, {}>({
    name: 'PlayerRecord',
    description: 'Player record.',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        player: {
            type: GraphQLNonNull(playerBasic),
            description: 'Player the record represents',
        },
        record: {
            type: GraphQLNonNull(playerGameRecord),
            description: 'Record of the player.',
        },
    }),
});
