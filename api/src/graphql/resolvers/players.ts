import { Player } from "../../lib/types";
import Players from '../../db/players';

interface PlayerListQueryArguments {
    first: number;
    offset: number;
}

export async function players({first = 25, offset = 0}: PlayerListQueryArguments): Promise<Player[]> {
    const allPlayers = Players.getInstance().all();
    if (offset >= allPlayers.length) {
        return [];
    }

    return allPlayers.slice(offset, offset + first);
}
