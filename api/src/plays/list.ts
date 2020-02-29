import Plays from '../db/plays';
import { Play } from '../lib/types';
import { Request } from 'express';
import { getListParams, isPlay } from '../common/utils';
import DataLoader from '../graphql/DataLoader';

export default async function list(req: Request): Promise<Array<Play>> {
    const [first, offset] = getListParams(req);
    const loader = DataLoader();

    const plays = await loader.playLoader.loadMany(
        Plays.getInstance().allIds({first, offset})
    );
    return plays.filter(play => isPlay(play)).map(play => play as Play);
}
