import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLList,
} from 'graphql';

import scoreStats from './scoreStats';
import gamePlayerRecord from './gamePlayerRecord';
import { GameStandings, GameStandingsGraphQL, Player } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';
import { isPlayer, parseID } from '../../common/utils';
import { playerRecordToGraphQL } from './playerRecord';

export async function gameStandingsToGraphQL(gameStandings: GameStandings, loader: MyLeaderboardLoader): Promise<GameStandingsGraphQL> {
    const playerIds = Object.keys(gameStandings.records).map(id => parseID(id));
    const players = await loader.playerLoader.loadMany(playerIds);

    return {
        scoreStats: gameStandings.scoreStats,
        records: await Promise.all(players.filter(player => isPlayer(player))
            .map(player => player as Player)
            .map(async player => ({
                    player,
                    record: await playerRecordToGraphQL(gameStandings.records[player.id], loader),
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
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(gamePlayerRecord))),
        },
    }),
});
