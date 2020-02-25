import { Game, GameStandings } from "../../lib/types";
import Games from '../../db/games';
import { gameStandings } from "../../games/standings";

interface GameListQueryArguments {
    first: number;
    offset: number;
}

export async function resolveGames({first = 25, offset = 0}: GameListQueryArguments): Promise<Game[]> {
    const allGames = Games.getInstance().allWithImages();
    if (offset >= allGames.length) {
        return [];
    }

    return allGames.slice(offset, offset + first);
}

interface GameStandingsQueryArguments {
    id: number;
}

export async function resolveGameStandings({id}: GameStandingsQueryArguments): Promise<GameStandings> {
    return gameStandings(id);
}
