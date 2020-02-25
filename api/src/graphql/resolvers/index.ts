import { GraphQLDateTime } from 'graphql-iso-date';
import {
    resolvePlayers as players,
    resolvePlayerRecord as playerRecord,
} from './players';
import { resolveGames as games } from './games';

const resolvers = {
    DateTime: GraphQLDateTime,
    players,
    playerRecord,
    games,
};

export default resolvers;