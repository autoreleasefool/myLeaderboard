import { Player } from '../lib/types';
import { getListQueryParams, isPlayer, parseID } from '../common/utils';
import DataLoader from '../graphql/DataLoader';
import { Request } from 'express';
import Players from '../db/players';

export default async function list(req: Request): Promise<Array<Player>> {
    const listQueryArgs = getListQueryParams(req);
    const loader = DataLoader();

    const players = await loader.playerLoader.loadMany(
        Players.getInstance().allIds(listQueryArgs)
    );
    return players.filter(player => isPlayer(player)) as Player[];
}
