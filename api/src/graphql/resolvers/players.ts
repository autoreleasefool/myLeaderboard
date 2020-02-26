import { Player, PlayerStandingsGraphQL } from "../../lib/types";
import Players from '../../db/players';
import { playerRecord } from "../../players/record";
import { addPlayer } from "../../players/new";
import { playerStandingsToGraphQL, parseID } from "../../common/utils";
import { ListArguments } from "../../db/table";

interface PlayerArguments {
    id: string;
}

interface PlayerRecordQueryArguments {
    id: string;
    game: string;
}

interface CreatePlayerArguments {
    name: string;
    username: string;
}

export async function resolvePlayer({id}: PlayerArguments): Promise<Player | undefined> {
    return Players.getInstance().findByIdWithAvatar(parseID(id));
}

export async function resolvePlayers(args: ListArguments): Promise<Array<Player>> {
    return Players.getInstance().allWithAvatars(args);
}

export async function resolvePlayerRecord({id, game}: PlayerRecordQueryArguments): Promise<PlayerStandingsGraphQL> {
    const standings = await playerRecord(parseInt(id, 10), parseInt(game, 10));
    return playerStandingsToGraphQL(standings);
}

export async function resolveCreatePlayer({name, username}: CreatePlayerArguments): Promise<Player> {
    return addPlayer(name, username);
}
