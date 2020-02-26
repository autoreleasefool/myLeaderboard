import { Play } from "../../lib/types";
import Plays from "../../db/plays";
import { recordPlay } from "../../plays/record";
import { ListArguments } from "../../db/table";
import { parseID } from "../../common/utils";

interface PlayArguments {
    id: string;
}

interface RecordPlayArguments {
    players: Array<string>;
    winners: Array<string>;
    scores?: Array<number>;
    game: string;
}

export async function resolvePlay({id}: PlayArguments): Promise<Play | undefined> {
    return Plays.getInstance().findById(parseID(id));
}

export async function resolvePlays(args: ListArguments): Promise<Array<Play>> {
    return Plays.getInstance().all(args);
}

export async function resolveRecordPlay({players, winners, scores, game}: RecordPlayArguments): Promise<Play> {
    return recordPlay(
        players.map(player => parseInt(player, 10)),
        winners.map(winner => parseInt(winner, 10)),
        scores,
        parseInt(game, 10)
    );
}
