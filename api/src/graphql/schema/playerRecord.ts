import {
    GraphQLObjectType,
    GraphQLNonNull,
} from 'graphql';

import playerRecord from './playerGameRecord';
import playerBasic from './playerBasic';

export default new GraphQLObjectType<void, void, {}>({
    name: 'PlayerRecord',
    description: 'Player record',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        player: {
            type: GraphQLNonNull(playerBasic),
        },
        record: {
            type: GraphQLNonNull(playerRecord),
        },
    }),
});
