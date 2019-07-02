import Octo from './Octo';

export async function allGames(): Promise<Array<string>> {
    const contents = await Octo.getInstance().dir('data');

    const games: Array<string> = [];
    for (const content of contents) {
        if (content.type === 'file' && content.name.endsWith('.json')) {
            games.push(content.name.split('.')[0]);
        }
    }
    return games;
}
