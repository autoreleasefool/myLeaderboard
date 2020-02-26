import { Game, GameStandingsGraphQL } from "../../lib/types";
import Games from '../../db/games';
import { gameStandings } from "../../games/standings";
import { gameStandingsToGraphQL, parseID } from "../../common/utils";
import { addGame } from "../../games/new";
import { ListArguments } from "../../db/table";

interface GameArguments {
    id: string;
}

interface GameStandingsQueryArguments {
    id: string;
}

interface CreateGameArguments {
    name: string;
    hasScores: boolean;
}

export async function resolveGame({id}: GameArguments): Promise<Game | undefined> {
    return Games.getInstance().findByIdWithImage(parseID(id));
}

export async function resolveGames(args: ListArguments): Promise<Array<Game>> {
    return Games.getInstance().allWithImages(args);
}

export async function resolveGameStandings({id}: GameStandingsQueryArguments): Promise<GameStandingsGraphQL> {
    const standings = await gameStandings(parseInt(id, 10));
    return gameStandingsToGraphQL(standings);
}

export async function resolveCreateGame({name, hasScores}: CreateGameArguments): Promise<Game> {
    return addGame(name, hasScores);
}
