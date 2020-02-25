import { Game } from "../../lib/types";
import Games from '../../db/games';

interface GameQueryArguments {
    id: number;
}

export async function game({id}: GameQueryArguments): Promise<Game | undefined> {
    return Games.getInstance().findById(id);
}

interface GameListQueryArguments {
    first: number;
    offset: number;
}

export async function games({first = 25, offset = 0}: GameListQueryArguments): Promise<Game[]> {
    const allGames = Games.getInstance().all();
    if (offset >= allGames.length) {
        return [];
    }

    return allGames.slice(offset, offset + first);
}
