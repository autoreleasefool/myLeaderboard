import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLString,
    GraphQLList,
} from 'graphql';

import record from './record';
import scoreStats from './scoreStats';
import playerVSRecord from './playerVSRecord';
import { PlayerRecord, PlayerRecordGraphQL, Player } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';
import { isPlayer } from '../../common/utils';

export async function playerRecordToGraphQL(playerRecord: PlayerRecord, loader: MyLeaderboardLoader): Promise<PlayerRecordGraphQL> {
    const playerIds = Object.keys(playerRecord.records);
    const players = await loader.playerLoader.loadMany(playerIds);

    return {
        scoreStats: playerRecord.scoreStats,
        lastPlayed: playerRecord.lastPlayed,
        overallRecord: playerRecord.overallRecord,
        records: players.filter(player => isPlayer(player))
            .map(player => player as Player)
            .map(player => ({
                player,
                record: playerRecord.records[player.id],
            })),
    };
}

export default new GraphQLObjectType<void, void, {}>({
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
