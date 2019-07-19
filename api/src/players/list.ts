import { Request } from 'express';
import Octo from '../lib/Octo';
import { Player } from '../lib/types';

export default async function list(req: Request): Promise<Array<Player>> {
    const includeAvatars: boolean = req.body.includeAvatars;
    if (includeAvatars != null && includeAvatars !== true && includeAvatars !== false) {
        throw new Error(`"includeAvatars" must be a boolean value. Default is true.`);
    }

    return Octo.getInstance().players(includeAvatars != null ? includeAvatars : true);
}
