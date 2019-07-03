import Octo from '../lib/Octo';
import { GenericPlayer } from '../lib/types';

export default async function list(): Promise<Array<GenericPlayer>> {
    return Octo.getInstance().players();
}
