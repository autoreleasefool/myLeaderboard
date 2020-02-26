import Players from '../db/players';
import { Player } from '../lib/types';

export default async function list(): Promise<Array<Player>> {
    return Players.getInstance().allWithAvatars({});
}
