import {
    GraphQLObjectType,
    GraphQLList,
    GraphQLNonNull,
} from 'graphql';

import scoreStats from './scoreStats';
import record from './record';
import playerVSRecord from './playerVSRecord';

export default new GraphQLObjectType({
    name: 'PlayerStandings',
    description: 'Player record for a game against all opponents',
    fields: () => ({
        scoreStats: {
            type: scoreStats,
        },
        overallRecord: {
            type: GraphQLNonNull(record),
        },
        records: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerVSRecord)))
        },
    }),
});
