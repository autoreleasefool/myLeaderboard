import {
    GraphQLObjectType,
    GraphQLNonNull,
} from 'graphql';

import playerRecord from './playerRecord';
import playerBasic from './playerBasic';

export default new GraphQLObjectType<void, void, {}>({
    name: 'GamePlayerRecord',
    description: 'Player record for a game',
    fields: () => ({
        player: {
            type: GraphQLNonNull(playerBasic),
        },
        record: {
            type: GraphQLNonNull(playerRecord),
        },
    }),
});
