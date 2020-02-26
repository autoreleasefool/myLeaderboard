import Plays from '../db/plays';
import { Play } from '../lib/types';

export default async function list(): Promise<Array<Play>> {
    return Plays.getInstance().all({});
}
