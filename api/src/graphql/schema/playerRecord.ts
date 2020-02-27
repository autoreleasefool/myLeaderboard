import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLString,
    GraphQLList,
} from 'graphql';

import record from './record';
import scoreStats from './scoreStats';
import playerVSRecord from './playerVSRecord';

export default new GraphQLObjectType({
    name: 'PlayerRecord',
    description: 'Player record',
    fields: () => ({
        lastPlayed: {
            type: GraphQLString,
        },
        overallRecord: {
            type: GraphQLNonNull(record),
        },
        scoreStats: {
            type: scoreStats,
        },
        records: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerVSRecord))),
        },
    }),
});
