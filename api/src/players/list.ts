import { Player } from '../lib/types';
import { getListQueryParams, isPlayer, parseID } from '../common/utils';
import DataLoader from '../graphql/DataLoader';
import { Request } from 'express';
import Players from '../db/players';

export default async function list(req: Request): Promise<Array<Player>> {
    const boardId = parseID(req.params.boardId);
    if (boardId === -1) {
        throw new Error(`Invalid board id "${boardId}"`);
    }

    const listQueryArgs = getListQueryParams(req);
    const loader = DataLoader();

    const players = await loader.playerLoader.loadMany(
        Players.getInstance().allIds(listQueryArgs)
    );
    return players.filter(player => isPlayer(player) && player.board === boardId) as Player[];
}
