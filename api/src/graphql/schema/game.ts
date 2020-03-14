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
import { Game } from '../../lib/types';
import { SchemaContext, ListQueryArguments, DEFAULT_PAGE_SIZE} from '../schema';
import play from './play';
import Plays from '../../db/plays';

interface StandingsArguments {
    ignoreBanished: boolean;
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
                ignoreBanished: {
                    type: GraphQLBoolean,
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (game, {ignoreBanished}: StandingsArguments, {loader}) =>
                gameRecordToGraphQL(
                    game.id,
                    await generateGameStandings(game.id, ignoreBanished, loader),
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
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (game, {first, offset}: ListQueryArguments, {loader}) => {
                const plays = Plays.getInstance().all({
                    first: first ? first : DEFAULT_PAGE_SIZE,
                    offset: offset ? offset : 0,
                    reverse: true,
                    filter: play => play.game === game.id
                });
                for (const play of plays) {
                    loader.playLoader.prime(play.id, play);
                }
                return plays;
            }
        }
    }),
});
