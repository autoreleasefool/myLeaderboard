import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLList,
} from 'graphql';

import scoreStats from './scoreStats';
import gamePlayerRecord from './gamePlayerRecord';

export default new GraphQLObjectType({
    name: 'PlayerRecord',
    description: 'Player record',
    fields: () => ({
        scoreStats: {
            type: scoreStats,
        },
        records: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(gamePlayerRecord))),
        },
    }),
});
