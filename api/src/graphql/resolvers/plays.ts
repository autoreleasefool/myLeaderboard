import { Play } from "../../lib/types";
import Plays from "../../db/plays";

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
