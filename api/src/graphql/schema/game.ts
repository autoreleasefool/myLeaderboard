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
            type: GraphQLNonNull(gameRecord),
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (game, _, {loader}) =>
                gameRecordToGraphQL(
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
            resolve: async (game, {first, offset}: ListQueryArguments, {loader}) => {
                const plays = Plays.getInstance().all({
                    first: first ? first : DEFAULT_PAGE_SIZE,
                    offset: offset ? offset : 0,
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
