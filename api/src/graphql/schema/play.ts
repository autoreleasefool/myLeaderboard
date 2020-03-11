import {
    GraphQLObjectType,
    GraphQLNonNull,
    GraphQLID,
    GraphQLList,
    GraphQLInt,
} from 'graphql';
import { Play, PlayGQL, Player } from '../../lib/types';
import { MyLeaderboardLoader } from '../DataLoader';
import { isPlayer } from '../../common/utils';
import playerBasic from './playerBasic';
import { SchemaContext } from '../schema';
import gameBasic from './gameBasic';
import { GraphQLDateTime } from 'graphql-iso-date';

export async function playToGraphQL(play: Play, loader: MyLeaderboardLoader): Promise<PlayGQL> {
    const players = await loader.playerLoader.loadMany(play.players);
    const game = await loader.gameLoader.load(play.game);

    return {
        ...play,
        game,
        players: players.filter(player => isPlayer(player))  as Player[],
        winners: (players.filter(player => isPlayer(player))  as Player[])
            .filter(player => player.id in play.winners),
    };
}

export default new GraphQLObjectType<Play, SchemaContext, {}>({
    name: 'Play',
    description: 'Play from the MyLeaderboard API.',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
            description: 'Unique ID.',
        },
        playedOn: {
            type: GraphQLNonNull(GraphQLDateTime),
            description: 'Date and time the play was recorded.',
        },
        scores: {
            type: GraphQLList(GraphQLNonNull(GraphQLInt)),
            description: 'Scores for the game. Order is in respect to `players`.'
        },
        game: {
            type: GraphQLNonNull(gameBasic),
            description: 'Game that was played.',
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (play, _, {loader}) => loader.gameLoader.load(play.game),
        },
        players: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerBasic))),
            description: 'Players that played in the game.',
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (play, _, {loader}) => loader.playerLoader.loadMany(play.players),
        },
        winners: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(playerBasic))),
            description: 'Winners of the game.',
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (play, _, {loader}) => loader.playerLoader.loadMany(play.winners),
        },
    }),
});
