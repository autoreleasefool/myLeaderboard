import { Player } from '../lib/types';
import { getListParams, isPlayer } from '../common/utils';
import DataLoader from '../graphql/DataLoader';
import { Request } from 'express';
import Players from '../db/players';

export default async function list(req: Request): Promise<Array<Player>> {
    const [first, offset] = getListParams(req);
    const loader = DataLoader();

    const players = await loader.playerLoader.loadMany(Players.getInstance().allIds({first, offset}).map(id => String(id)));
    return players.filter(player => isPlayer(player)).map(player => player as Player)
}
