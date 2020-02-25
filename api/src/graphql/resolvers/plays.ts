import { Play } from "../../lib/types";
import Plays from "../../db/plays";
import { recordPlay } from "../../plays/record";

interface PlayListArguments {
    first: number;
    offset: number;
}

export async function resolvePlays({first = 25, offset = 0}: PlayListArguments): Promise<Array<Play>> {
    const allPlays = Plays.getInstance().all();
    if (offset >= allPlays.length) {
        return [];
    }

    return allPlays.slice(offset, offset + first);
}

interface RecordPlayArguments {
    players: Array<number>;
    winners: Array<number>;
    scores?: Array<number>;
    game: number;
}

export async function resolveRecordPlay({players, winners, scores, game}: RecordPlayArguments): Promise<Play> {
    return recordPlay(players, winners, scores, game);
}
