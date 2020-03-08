import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLID,
    GraphQLList,
    GraphQLInt,
} from 'graphql';
import { PlayNext, PlayGQL, PlayerNext } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';
import { isPlayer } from '../../common/utils';
import playerBasic from './playerBasic';
import { SchemaContext } from '../schema';
import gameBasic from './gameBasic';
import { GraphQLDateTime } from 'graphql-iso-date';

export async function playToGraphQL(play: PlayNext, loader: MyLeaderboardLoader): Promise<PlayGQL> {
    const players = await loader.playerLoader.loadMany(play.players);
    const game = await loader.gameLoader.load(play.game);

    return {
        ...play,
        game,
        players: players.filter(player => isPlayer(player))  as PlayerNext[],
        winners: (players.filter(player => isPlayer(player))  as PlayerNext[])
            .filter(player => player.id in play.winners),
    };
}

export default new GraphQLObjectType<PlayNext, SchemaContext, {}>({
    name: 'Play',
    description: 'Play from the MyLeaderboard API',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
        },
        playedOn: {
            type: GraphQLNonNull(GraphQLDateTime),
        },
        scores: {
            type: GraphQLList(GraphQLNonNull(GraphQLInt)),
        },
        game: {
            type: GraphQLNonNull(gameBasic),
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (play, _, {loader}) => loader.gameLoader.load(play.game),
        },
        players: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerBasic))),
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (play, _, {loader}) => loader.playerLoader.loadMany(play.players),
        },
        winners: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerBasic))),
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (play, _, {loader}) => loader.playerLoader.loadMany(play.winners),
        },
    }),
});
