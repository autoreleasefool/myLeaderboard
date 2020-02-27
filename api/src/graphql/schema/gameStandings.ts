import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLList,
} from 'graphql';

import scoreStats from './scoreStats';
import gamePlayerRecord from './gamePlayerRecord';

export default new GraphQLObjectType({
    name: 'GameStandings',
    description: 'Standings for a game',
    fields: () => ({
        scoreStats: {
            type: scoreStats,
        },
        records: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(gamePlayerRecord))),
        },
    }),
});
