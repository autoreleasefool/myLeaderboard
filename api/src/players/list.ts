import { Request } from 'express';
import Players from '../db/players';
import { Player } from '../lib/types';

export default async function list(req: Request): Promise<Array<Player>> {
    const includeAvatars = Boolean(req.query.includeAvatars);

    if (includeAvatars) {
        return await Players.getInstance().allWithAvatars();
    } else {
        return Players.getInstance().all();
    }
}
