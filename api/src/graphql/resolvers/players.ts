import { Player, PlayerStandings } from "../../lib/types";
import Players from '../../db/players';
import { playerRecord } from "../../players/record";

interface PlayerListQueryArguments {
    first: number;
    offset: number;
}

export async function resolvePlayers({first = 25, offset = 0}: PlayerListQueryArguments): Promise<Player[]> {
    const allPlayers = Players.getInstance().all();
    if (offset >= allPlayers.length) {
        return [];
    }

    return allPlayers.slice(offset, offset + first);
}

interface PlayerRecordQueryArguments {
    id: number;
    game: number;
}

export async function resolvePlayerRecord({id, game}: PlayerRecordQueryArguments): Promise<PlayerStandings> {
    return playerRecord(id, game);
}
