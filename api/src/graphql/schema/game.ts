import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLNonNull,
    GraphQLBoolean,
    GraphQLID,
    GraphQLInt,
    GraphQLList,
} from 'graphql';
import gameStandings, { gameStandingsToGraphQL } from './gameStandings';
import { gameStandings as generateGameStandings } from '../../games/standings';
import { Game } from '../../lib/types';
import { SchemaContext, ListQueryArguments, DEFAULT_PAGE_SIZE} from '../schema';
import play from './play';
import Plays from '../../db/plays';

export default new GraphQLObjectType<Game, SchemaContext, any>({
    name: 'Game',
    description: 'Game from the MyLeaderboard API with complex information',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        id: {
            type: GraphQLNonNull(GraphQLID),
        },
        name: {
            type: GraphQLNonNull(GraphQLString),
        },
        hasScores: {
            type: GraphQLNonNull(GraphQLBoolean),
        },
        image: {
            type: GraphQLString,
        },
        standings: {
            type: GraphQLNonNull(gameStandings),
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (game, _, {loader}) =>
                gameStandingsToGraphQL(
                    game.id,
                    await generateGameStandings(game.id, loader),
                    loader
                ),
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
            resolve: async (game: Game, {first, offset}: ListQueryArguments, {loader}) => {
                const plays = Plays.getInstance().allByPlayerId(game.id, {
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
