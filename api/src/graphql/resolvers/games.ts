import { Game } from "../../lib/types";
import Games from '../../db/games';

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
