import { Player, PlayerStandingsGraphQL } from "../../lib/types";
import Players from '../../db/players';
import { playerRecord } from "../../players/record";
import { addPlayer } from "../../players/new";
import { playerStandingsToGraphQL } from "../../common/utils";

interface PlayerListQueryArguments {
    first: number;
    offset: number;
}

export async function resolvePlayers({first = 25, offset = 0}: PlayerListQueryArguments): Promise<Array<Player>> {
    const allPlayers = await Players.getInstance().allWithAvatars();
    if (offset >= allPlayers.length) {
        return [];
    }

    return allPlayers.slice(offset, offset + first);
}

interface PlayerRecordQueryArguments {
    id: string;
    game: string;
}

export async function resolvePlayerRecord({id, game}: PlayerRecordQueryArguments): Promise<PlayerStandingsGraphQL> {
    const standings = await playerRecord(parseInt(id, 10), parseInt(game, 10));
    return playerStandingsToGraphQL(standings);
}

interface CreatePlayerArguments {
    name: string;
    username: string;
}

export async function resolveCreatePlayer({name, username}: CreatePlayerArguments): Promise<Player> {
    return addPlayer(name, username);
}
