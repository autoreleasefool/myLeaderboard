import { allGames } from '../lib/Game';

export default async function list(): Promise<Array<string>> {
    return allGames();
}
