import {
    GraphQLObjectType,
    GraphQLSchema,
    GraphQLNonNull,
    GraphQLID,
    GraphQLList,
    GraphQLInt,
    GraphQLBoolean,
    GraphQLString
} from 'graphql';

import player from './schema/player';
import game from './schema/game';
import Players from '../db/players';
import Games from '../db/games';
import play from './schema/play';
import Plays from '../db/plays';
import { parseID } from '../common/utils';
import { anyUpdatesSince } from '../misc/hasUpdates';
import { addGame } from '../games/new';
import { addPlayer } from '../players/new';
import { recordPlay } from '../plays/record';
import { MyLeaderboardLoader } from './DataLoader';
import { ListArguments } from '../db/table';

export interface SchemaContext {
    loader: MyLeaderboardLoader;
}

interface ItemQueryArgs {
    id: string;
}

interface HasUpdatesQueryArgs {
    since: string;
}

const RootQuery = new GraphQLObjectType<any, SchemaContext, any>({
    name: 'Query',
    description: 'Realize Root Query',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({

        player: {
            type: player,
            args: {
                id: {
                    type: GraphQLNonNull(GraphQLID),
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => loader.playerLoader.load(parseID(id)),
        },

        players: {
            type: GraphQLNonNull(GraphQLList(player)),
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {first, offset}: ListArguments, {loader}) => {
                const players = await Players.getInstance().allWithAvatars({first, offset});
                for (const player of players) {
                    loader.playerLoader.prime(player.id, player);
                }
                return players;
            }
        },

        game: {
            type: game,
            args: {
                id: {
                    type: GraphQLNonNull(GraphQLID),
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => loader.gameLoader.load(parseID(id)),
        },

        games: {
            type: GraphQLNonNull(GraphQLList(game)),
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {first, offset}: ListArguments, {loader}) => {
                const games = await Games.getInstance().allWithImages({first, offset});
                for (const game of games) {
                    loader.gameLoader.prime(game.id, game);
                }
                return games;
            },
        },

        play: {
            type: play,
            args: {
                id: {
                    type: GraphQLID,
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => loader.playLoader.load(parseID(id)),
        },

        plays: {
            type: GraphQLList(GraphQLNonNull(play)),
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, args: ListArguments, {loader}) => {
                const plays = await Plays.getInstance().all(args);
                for (const play of plays) {
                    loader.playLoader.prime(play.id, play);
                }
                return plays;
            }
        },

        hasAnyUpdates: {
            type: GraphQLNonNull(GraphQLBoolean),
            args: {
                since: {
                    type: GraphQLString,
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {since}: HasUpdatesQueryArgs) => anyUpdatesSince(new Date(since)),
        }
    }),
});

interface CreatePlayerArgs {
    displayName: string;
    username: string;
}

interface CreateGameArgs {
    name: string;
    hasScores: boolean;
}

interface RecordPlayArgs {
    players: Array<string>;
    winners: Array<string>;
    game: string;
    scores?: Array<number>;
}

const RootMutation = new GraphQLObjectType<any, SchemaContext, any>({
    name: 'Mutation',
    description: 'Realize Root Mutation',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        createPlayer: {
            type: player,
            args: {
                displayName: {
                    type: GraphQLNonNull(GraphQLString),
                },
                username: {
                    type: GraphQLNonNull(GraphQLString),
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {displayName, username}: CreatePlayerArgs) => addPlayer(displayName, username),
        },

        createGame: {
            type: game,
            args: {
                name: {
                    type: GraphQLNonNull(GraphQLString),
                },
                hasScores: {
                    type: GraphQLNonNull(GraphQLBoolean),
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {name, hasScores}: CreateGameArgs) => addGame(name, hasScores),
        },

        recordPlay: {
            type: play,
            args: {
                players: {
                    type: GraphQLNonNull(GraphQLList(GraphQLNonNull(GraphQLID))),
                },
                winners: {
                    type: GraphQLNonNull(GraphQLList(GraphQLNonNull(GraphQLID))),
                },
                game: {
                    type: GraphQLNonNull(GraphQLID),
                },
                scores: {
                    type: GraphQLList(GraphQLNonNull(GraphQLInt)),
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {players, winners, game, scores}: RecordPlayArgs, {loader}) => {
                return await recordPlay(
                    players.map(player => parseID(player)),
                    winners.map(winner => parseID(winner)),
                    scores,
                    parseID(game),
                    loader
                );
            }
        }
    }),
});

export default new GraphQLSchema({
    query: RootQuery,
    mutation: RootMutation,
});
