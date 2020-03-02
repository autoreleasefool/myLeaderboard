import {
    GraphQLObjectType,
    GraphQLList,
    GraphQLNonNull,
} from 'graphql';

import scoreStats from './scoreStats';
import record from './record';
import playerVSRecord from './playerVSRecord';
import { PlayerStandings, PlayerStandingsGraphQL, Player } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';
import { isPlayer, parseID } from '../../common/utils';

export async function playerStandingsToGraphQL(playerStandings: PlayerStandings, loader: MyLeaderboardLoader): Promise<PlayerStandingsGraphQL> {
    const playerIds = Object.keys(playerStandings.records).map(id => parseID(id));
    const players = await loader.playerLoader.loadMany(playerIds);

    return {
        scoreStats: playerStandings.scoreStats,
        overallRecord: playerStandings.overallRecord,
        records: players.filter(player => isPlayer(player))
            .map(player => player as Player)
            .map(player => ({
                player,
                record: playerStandings.records[player.id],
            })),
    };
}

export default new GraphQLObjectType<void, void, {}>({
    name: 'PlayerStandings',
    description: 'Player record for a game against all opponents',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
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
