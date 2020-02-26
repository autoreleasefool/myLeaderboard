import { GraphQLDateTime } from 'graphql-iso-date';
import {
    resolvePlayer as player,
    resolvePlayers as players,
    resolvePlayerRecord as playerRecord,
    resolveCreatePlayer as createPlayer,
} from './players';
import {
    resolveGame as game,
    resolveGames as games,
    resolveGameStandings as gameStandings,
    resolveCreateGame as createGame,
} from './games';
import { resolveHasAnyUpdates as hasAnyUpdates } from './misc';
import {
    resolvePlay as play,
    resolvePlays as plays,
    resolveRecordPlay as recordPlay,
} from './plays';

const resolvers = {
    DateTime: GraphQLDateTime,

    player,
    players,
    playerRecord,
    createPlayer,

    game,
    games,
    gameStandings,
    createGame,

    hasAnyUpdates,

    play,
    plays,
    recordPlay,
};

export default resolvers;