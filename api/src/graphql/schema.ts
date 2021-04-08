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

import board from './schema/board';
import player from './schema/player';
import game from './schema/game';
import Players from '../db/players';
import Games from '../db/games';
import play, { playHasPlayers } from './schema/play';
import Plays from '../db/plays';
import { parseID } from '../common/utils';
import { anyUpdatesSince } from '../misc/hasUpdates';
import { addGame } from '../games/new';
import { addPlayer } from '../players/new';
import { recordPlay } from '../plays/record';
import { MyLeaderboardLoader } from './DataLoader';
import { GraphQLDateTime } from 'graphql-iso-date';
import { ListQueryArguments } from '../lib/types';
import { addBoard } from '../boards/new';

export const DEFAULT_PAGE_SIZE = 25;

export interface SchemaContext {
    loader: MyLeaderboardLoader;
}

interface ItemQueryArgs {
    id: string;
}

interface HasUpdatesQueryArgs {
    since: string;
}

export interface PlayerFilterArguments extends ListQueryArguments {
    board: string;
}

interface PlayFilterArguments extends ListQueryArguments {
    board: string;
    game?: string;
    players?: string[];
    reverse?: boolean
}

const RootQuery = new GraphQLObjectType<any, SchemaContext, any>({
    name: 'Query',
    description: 'Realize Root Query',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({

        player: {
            type: player,
            description: 'Find a single player.',
            args: {
                id: {
                    type: GraphQLNonNull(GraphQLID),
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => loader.playerLoader.load(parseID(id)),
        },

        players: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(player))),
            description: `Get a list of players, ordered by ID ascending. Default page size is ${DEFAULT_PAGE_SIZE}.`,
            args: {
                board: {
                    type: GraphQLNonNull(GraphQLID),
                },
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {board, first, offset}: PlayerFilterArguments , {loader}) => {
                const boardId = parseID(board);
                const players = await Players.getInstance().allWithAvatars({
                    first: first ? first : DEFAULT_PAGE_SIZE,
                    offset: offset ? offset : 0,
                    filter: player => player.board === boardId,
                });
                for (const player of players) {
                    loader.playerLoader.prime(player.id, player);
                }
                return players;
            }
        },

        game: {
            type: game,
            description: 'Find a single game.',
            args: {
                id: {
                    type: GraphQLNonNull(GraphQLID),
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => loader.gameLoader.load(parseID(id)),
        },

        games: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(game))),
            description: `Get a list of games, ordered by ID ascending. Default page size is ${DEFAULT_PAGE_SIZE}.`,
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {first, offset}: ListQueryArguments, {loader}) => {
                const games = await Games.getInstance().allWithImages({
                    first: first ? first : DEFAULT_PAGE_SIZE,
                    offset: offset ? offset : 0,
                });
                for (const game of games) {
                    loader.gameLoader.prime(game.id, game);
                }
                return games;
            },
        },

        play: {
            type: play,
            description: 'Find a single play.',
            args: {
                id: {
                    type: GraphQLID,
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => loader.playLoader.load(parseID(id)),
        },

        plays: {
            type: GraphQLNonNull(GraphQLList(GraphQLNonNull(play))),
            description: `Get a list of plays, ordered by ID ascending. Default page size is ${DEFAULT_PAGE_SIZE}. Filter by game or player`,
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
                game: {
                    type: GraphQLID,
                },
                players: {
                    type: GraphQLList(GraphQLNonNull(GraphQLID)),
                },
                reverse: {
                    type: GraphQLBoolean,
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {first, offset, board, game, players, reverse}: PlayFilterArguments, {loader}) => {
                const boardID = board ? parseID(board) : undefined;
                if (boardID === undefined) {
                    return [];
                }

                const gameID = game ? parseID(game) : undefined;
                const playerIDs = players && players.length > 0 ? players.map(id => parseID(id)) : undefined;
                const plays = await Plays.getInstance().all({
                    first: first ? first : DEFAULT_PAGE_SIZE,
                    offset: offset ? offset : 0,
                    filter: play => play.board === boardID &&
                        (gameID === undefined || play.game === gameID) &&
                        (!playerIDs || playHasPlayers(play, playerIDs)),
                    reverse,
                });
                for (const play of plays) {
                    loader.playLoader.prime(play.id, play);
                }
                return plays;
            }
        },

        hasAnyUpdates: {
            type: GraphQLNonNull(GraphQLBoolean),
            description: 'Returns true if there have been any updates to the database since the given date.',
            args: {
                since: {
                    type: GraphQLNonNull(GraphQLDateTime),
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {since}: HasUpdatesQueryArgs) => anyUpdatesSince(new Date(since)),
        }
    }),
});

interface CreateBoardArgs {
    boardName: string;
}

interface CreatePlayerArgs {
    board: string;
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
    board: string;
    scores?: Array<number>;
}

const RootMutation = new GraphQLObjectType<any, SchemaContext, any>({
    name: 'Mutation',
    description: 'Realize Root Mutation',
    // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
    fields: () => ({
        createBoard: {
            type: board,
            description: 'Create a new board.',
            args: {
                boardName: {
                    type: GraphQLNonNull(GraphQLString),
                },
            },
            resolve: async (_, {boardName}: CreateBoardArgs) => addBoard(boardName),
        },

        createPlayer: {
            type: player,
            description: 'Create a new player.',
            args: {
                board: {
                    type: GraphQLNonNull(GraphQLID),
                },
                displayName: {
                    type: GraphQLNonNull(GraphQLString),
                },
                username: {
                    type: GraphQLNonNull(GraphQLString),
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {board, displayName, username}: CreatePlayerArgs) => addPlayer(displayName, username, parseID(board)),
        },

        createGame: {
            type: game,
            description: 'Create a new game.',
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
            description: 'Record a play between at least two players.',
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
                board: {
                    type: GraphQLNonNull(GraphQLID),
                },
                scores: {
                    type: GraphQLList(GraphQLNonNull(GraphQLInt)),
                },
            },
            // eslint-disable-next-line  @typescript-eslint/explicit-function-return-type
            resolve: async (_, {players, winners, game, board, scores}: RecordPlayArgs, {loader}) => {
                return await recordPlay(
                    players.map(player => parseID(player)),
                    winners.map(winner => parseID(winner)),
                    scores,
                    parseID(game),
                    parseID(board),
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
