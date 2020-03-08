import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLList,
} from 'graphql';

import record from './record';
import scoreStats from './scoreStats';
import playerVSRecord from './playerVSRecord';
import { PlayerRecord, PlayerRecordGraphQL, Player } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';
import { isPlayer, parseID } from '../../common/utils';
import { GraphQLDateTime } from 'graphql-iso-date';
import gameBasic from './gameBasic';

export async function playerRecordToGraphQL(gameId: number, playerRecord: PlayerRecord, loader: MyLeaderboardLoader): Promise<PlayerRecordGraphQL> {
    const playerIds = Object.keys(playerRecord.records).map(id => parseID(id));
    const players = await loader.playerLoader.loadMany(playerIds);
    const game = await loader.gameLoader.load(gameId);

    return {
        game,
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
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        game: {
            type: GraphQLNonNull(gameBasic),
        },
        lastPlayed: {
            type: GraphQLDateTime,
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
