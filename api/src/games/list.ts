import Games from '../db/games';
import { Game } from '../lib/types';

export default async function list(): Promise<Array<Game>> {
    return Games.getInstance().allWithImages({});
}
