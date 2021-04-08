import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLBoolean,
    GraphQLID,
    GraphQLInt,
    GraphQLList,
} from 'graphql';
import gameRecord, { gameRecordToGraphQL } from './gameRecord';
import { gameStandings as generateGameStandings } from '../../games/standings';
import { Game, ListQueryArguments } from '../../lib/types';
import { SchemaContext, DEFAULT_PAGE_SIZE} from '../schema';
import play from './play';
import Plays from '../../db/plays';
import { parseID } from '../../common/utils';

interface StandingsArguments {
    board: string;
    ignoreBanished?: boolean;
}

interface MostRecentPlayArguments extends ListQueryArguments {
    board: string;
}

export default new GraphQLObjectType<Game, SchemaContext, any>({
    name: 'Game',
    description: 'Game from the MyLeaderboard API with complex information.',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
            description: 'Unique ID.',
        },
        name: {
            type: GraphQLNonNull(GraphQLString),
            description: 'Name of the game.',
        },
        hasScores: {
            type: GraphQLNonNull(GraphQLBoolean),
            description: 'Indicates if the game includes score keeping.',
        },
        image: {
            type: GraphQLString,
            description: 'Image for the game.',
        },
        standings: {
            type: GraphQLNonNull(gameRecord),
            description: 'Player vs player records, and score statistics for the game.',
            args: {
                board: {
                    type: GraphQLNonNull(GraphQLID),
                },
                ignoreBanished: {
                    type: GraphQLBoolean,
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (game, {board, ignoreBanished}: StandingsArguments, {loader}) =>
                gameRecordToGraphQL(
                    game.id,
                    await generateGameStandings(game.id, parseID(board), ignoreBanished ?? false, loader),
                    loader
                ),
        },
        recentPlays: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(play))),
            description: 'Most recent plays of the game.',
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                },
                board: {
                    type: GraphQLNonNull(GraphQLID),
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (game, {first, offset, board}: MostRecentPlayArguments, {loader}) => {
                const boardId = parseID(board);
                const plays = Plays.getInstance().all({
                    first: first ? first : DEFAULT_PAGE_SIZE,
                    offset: offset ? offset : 0,
                    reverse: true,
                    filter: play => play.game === game.id && play.board === boardId,
                });
                for (const play of plays) {
                    loader.playLoader.prime(play.id, play);
                }
                return plays;
            }
        }
    }),
});
