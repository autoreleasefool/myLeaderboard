import { Request } from 'express';
import Players from '../db/players';
import { Player } from '../lib/types';

export default async function list(req: Request): Promise<Array<Player>> {
    const includeAvatars: boolean = req.body.includeAvatars;
    if (includeAvatars != null && includeAvatars !== true && includeAvatars !== false) {
        throw new Error(`"includeAvatars" must be a boolean value. Default is true.`);
    }

    if (includeAvatars) {
        return await Players.getInstance().allWithAvatars();
    } else {
        return Players.getInstance().all();
    }
}
