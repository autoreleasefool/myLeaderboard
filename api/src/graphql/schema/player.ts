import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLID,
    GraphQLInt,
    GraphQLList,
} from 'graphql';
import playerRecord from './playerRecord';
import playerBasic from './playerBasic';

import { playerRecord as generatePlayerRecord } from '../../players/record';
import { playerStandingsToGraphQL } from './playerStandings';
import { Player } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';
import play from './play';
import Plays from '../../db/plays';
import { ListQueryArguments, DEFAULT_PAGE_SIZE } from '../schema';
import Games from '../../db/games';

interface QueryContext {
    loader: MyLeaderboardLoader;
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
        records: {
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerRecord))),
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (player: Player, {first, offset}: ListQueryArguments, {loader}) => {
                const gameIds = Games.getInstance().allIds({
                    first: first ? first : DEFAULT_PAGE_SIZE,
                    offset: offset ? offset : 0,
                });
                return Promise.all(gameIds.map(async gameId => playerStandingsToGraphQL(
                    await generatePlayerRecord(player.id, gameId, loader),
                    loader
                )));
            },
        },
        recentPlays: {
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(play))),
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (player: Player, {first, offset}: ListQueryArguments, {loader}) => {
                const plays = Plays.getInstance().allByPlayerId(player.id, {
                    first: first ? first : DEFAULT_PAGE_SIZE,
                    offset: offset ? offset : 0,
                });
                for (const play of plays) {
                    loader.playLoader.prime(play.id, play);
                }
                return plays;
            }
        }
    }),
});
