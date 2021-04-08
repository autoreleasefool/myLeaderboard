import Plays from '../db/plays';
import { Play } from '../lib/types';
import { Request } from 'express';
import { getListQueryParams, isPlay, parseID } from '../common/utils';
import DataLoader from '../graphql/DataLoader';

export default async function list(req: Request): Promise<Play[]> {
    const listQueryArgs = getListQueryParams(req);
    const loader = DataLoader();

    const plays = await loader.playLoader.loadMany(
        Plays.getInstance().allIds(listQueryArgs)
    );
    return plays.filter(play => isPlay(play)) as Play[];
}
