import {
    resolvePlayers as players,
    resolvePlayerRecord as playerRecord,
} from './players';
import { resolveGames as games } from './games';

const resolvers = {
    players,
    playerRecord,
    games,
};

export default resolvers;