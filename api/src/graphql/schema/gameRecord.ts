import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLList,
} from 'graphql';

import scoreStats from './scoreStats';
import playerRecord from './playerRecord';
import { Player, GameRecord, GameRecordGQL } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';
import { isPlayer, parseID } from '../../common/utils';
import { playerRecordToGraphQL } from './playerGameRecord';

export async function gameRecordToGraphQL(gameId: number, gameRecord: GameRecord, loader: MyLeaderboardLoader): Promise<GameRecordGQL> {
    const playerIds = Object.keys(gameRecord.records).map(id => parseID(id));
    const players = await loader.playerLoader.loadMany(playerIds);

    return {
        scoreStats: gameRecord.scoreStats,
        records: await Promise.all(players.filter(player => isPlayer(player))
            .map(player => player as Player)
            .map(async player => ({
                    player,
                    record: await playerRecordToGraphQL(gameId, gameRecord.records[player.id], loader),
                })
            )),
    };
}

export default new GraphQLObjectType<void, void, {}>({
    name: 'GameStandings',
    description: 'Standings for a game',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        scoreStats: {
            type: scoreStats,
        },
        records: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerRecord))),
        },
    }),
});
