import { PlayGraphQL } from "../../lib/types";
import Plays from "../../db/plays";
import { recordPlay } from "../../plays/record";
import { ListArguments } from "../../db/table";
import { parseID, playToGraphQL, filterDefined } from "../../common/utils";

interface PlayArguments {
    id: string;
}

interface RecordPlayArguments {
    players: Array<string>;
    winners: Array<string>;
    scores?: Array<number>;
    game: string;
}

export async function resolvePlay({id}: PlayArguments): Promise<PlayGraphQL | undefined> {
    const play = Plays.getInstance().findById(parseID(id));
    return play ? playToGraphQL(play) : undefined;
}

export async function resolvePlays(args: ListArguments): Promise<Array<PlayGraphQL>> {
    const plays = Plays.getInstance().all(args);
    return filterDefined(await Promise.all(plays.map(play => playToGraphQL(play))));
}

export async function resolveRecordPlay({players, winners, scores, game}: RecordPlayArguments): Promise<PlayGraphQL | undefined> {
    return playToGraphQL(
        await recordPlay(
            players.map(player => parseInt(player, 10)),
            winners.map(winner => parseInt(winner, 10)),
            scores,
            parseInt(game, 10)
        )
    );
}
