import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLID,
    GraphQLList,
    GraphQLInt,
} from 'graphql';
import game from './game';
import { Play, PlayGraphQL, Player } from '../../lib/types';
import { MyLeaderboardLoader } from '../dataloader';
import { isPlayer } from '../../common/utils';
import playerBasic from './playerBasic';
import { SchemaContext } from '../schema';

export async function playToGraphQL(play: Play, loader: MyLeaderboardLoader): Promise<PlayGraphQL | undefined> {
    const playerIds = play.players.map(id => String(id));
    const players = await loader.playerLoader.loadMany(playerIds);

    const game = await loader.gameLoader.load(String(play.game));
    if (!game) {
        return undefined;
    }

    return {
        ...play,
        players: players.filter(player => isPlayer(player))
            .map(player => player as Player),
        game,
        winners: players.filter(player => isPlayer(player))
            .map(player => player as Player)
            .filter(player => player.id in play.winners),
    };
}

export default new GraphQLObjectType<Play, SchemaContext, {}>({
    name: 'Play',
    description: 'Play from the MyLeaderboard API',
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
        },
        playedOn: {
            type: GraphQLNonNull(GraphQLString),
        },
        scores: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(GraphQLInt))),
        },
        game: {
            type: GraphQLNonNull(game),
            resolve: async (play, _, {loader}) => loader.gameLoader.load(String(play.game)),
        },
        players: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerBasic))),
            resolve: async (play, _, {loader}) => loader.playerLoader.loadMany(
                play.players.map(id => String(id)),
            ),
        },
        winners: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerBasic))),
            resolve: async (play, _, {loader}) => loader.playerLoader.loadMany(
                play.winners.map(id => String(id)),
            ),
        },
    }),
});
