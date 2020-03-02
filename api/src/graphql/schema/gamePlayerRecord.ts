import {
    GraphQLObjectType,
    GraphQLNonNull,
} from 'graphql';

import playerRecord from './playerRecord';
import playerBasic from './playerBasic';

export default new GraphQLObjectType<void, void, {}>({
    name: 'GamePlayerRecord',
    description: 'Player record for a game',
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
