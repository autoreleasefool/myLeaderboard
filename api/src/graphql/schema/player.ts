import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLID,
} from 'graphql';
import playerRecord from './playerRecord';
import { parseID } from '../../common/utils';
import playerBasic from './playerBasic';

import { playerRecord as generatePlayerRecord } from '../../players/record';
import { playerStandingsToGraphQL } from './playerStandings';
import { Player } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';

interface QueryContext {
    loader: MyLeaderboardLoader;
}

interface PlayerRecordArguments {
    gameId: string;
}

export default new GraphQLObjectType<Player, QueryContext, any>({
    name: 'Player',
    description: 'Player from the MyLeaderboard API with complex information',
    extensions: playerBasic,
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
        },
        username: {
            type: GraphQLNonNull(GraphQLString),
        },
        displayName: {
            type: GraphQLNonNull(GraphQLString),
        },
        avatar: {
            type: GraphQLString,
        },
        record: {
            args: {
                gameId: {
                    type: GraphQLNonNull(GraphQLID),
                }
            },
            type: GraphQLNonNull(playerRecord),
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (player: Player, {gameId}: PlayerRecordArguments, {loader}) =>
                playerStandingsToGraphQL(
                    await generatePlayerRecord(player.id, parseID(gameId), loader), loader
                ),
        }
    }),
});
