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
    players: Array<string>;
    winners: Array<string>;
    scores?: Array<number>;
    game: string;
}

export async function resolveRecordPlay({players, winners, scores, game}: RecordPlayArguments): Promise<Play> {
    return recordPlay(
        players.map(player => parseInt(player, 10)),
        winners.map(winner => parseInt(winner, 10)),
        scores,
        parseInt(game, 10)
    );
}
