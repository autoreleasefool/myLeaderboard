import { GraphQLDateTime } from 'graphql-iso-date';
import {
    resolvePlayers as players,
    resolvePlayerRecord as playerRecord,
} from './players';
import {
    resolveGames as games,
    resolveGameStandings as gameStandings
} from './games';
import { resolveHasAnyUpdates as hasAnyUpdates } from './misc';

const resolvers = {
    DateTime: GraphQLDateTime,
    players,
    playerRecord,
    games,
    gameStandings,
    hasAnyUpdates,
};

export default resolvers;