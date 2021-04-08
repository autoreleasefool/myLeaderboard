import Games from '../db/games';
import { Game } from '../lib/types';
import DataLoader from '../graphql/DataLoader';
import { Request } from 'express';
import { getListQueryParams, isGame } from '../common/utils';

export default async function list(req: Request): Promise<Array<Game>> {
    const listQueryArgs = getListQueryParams(req);
    const loader = DataLoader();

    const games = await loader.gameLoader.loadMany(
        Games.getInstance().allIds(listQueryArgs)
    );
    return games.filter(game => isGame(game)) as Game[];
}
