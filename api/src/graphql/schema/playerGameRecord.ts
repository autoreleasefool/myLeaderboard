import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLList,
} from 'graphql';

import record from './record';
import scoreStats from './scoreStats';
import playerVSRecord from './playerRecordVS';
import { PlayerRecord, PlayerGameRecordGQL, Player } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';
import { isPlayer, parseID } from '../../common/utils';
import { GraphQLDateTime } from 'graphql-iso-date';
import gameBasic from './gameBasic';

export async function playerRecordToGraphQL(gameId: number, playerRecord: PlayerRecord, loader: MyLeaderboardLoader): Promise<PlayerGameRecordGQL> {
    const playerIds = Object.keys(playerRecord.records).map(id => parseID(id));
    const players = await loader.playerLoader.loadMany(playerIds);
    const game = await loader.gameLoader.load(gameId);

    return {
        game,
        scoreStats: playerRecord.scoreStats,
        lastPlayed: playerRecord.lastPlayed,
        overallRecord: playerRecord.overallRecord,
        records: (players.filter(player => isPlayer(player)) as Player[])
            .map(player => ({
                opponent: player,
                record: playerRecord.records[player.id],
            })),
    };
}

export default new GraphQLObjectType<void, void, {}>({
    name: 'PlayerGameRecord',
    description: 'Player record for a game.',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        game: {
            type: GraphQLNonNull(gameBasic),
            description: 'Game the record represents.',
        },
        lastPlayed: {
            type: GraphQLDateTime,
            description: 'Date and time the player last played the game.',
        },
        overallRecord: {
            type: GraphQLNonNull(record),
            description: 'All time record for the player.',
        },
        scoreStats: {
            type: scoreStats,
            description: 'All time score statistics for the player.',
        },
        records: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerVSRecord))),
            description: 'Records against other players.',
        },
    }),
});
