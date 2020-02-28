import { parseID } from '../common/utils';
import Games from '../db/games';
import Players from '../db/players';
import Plays from '../db/plays';
import DataLoader from 'dataloader';
import { Player, Game, Play } from '../lib/types';

export interface MyLeaderboardLoader {
    playerLoader: DataLoader<string, Player>;
    gameLoader: DataLoader<string, Game>;
    playLoader: DataLoader<string, Play>;
}

async function batchPlayers(keys: readonly string[]) {
    let ids = keys.map(key => parseID(key));
    return Players.getInstance().allByIdsWithAvatars(ids);
}

async function batchGames(keys: readonly string[]) {
    let ids = keys.map(key => parseID(key));
    return Games.getInstance().allByIdsWithImages(ids);
}

async function batchPlays(keys: readonly string[]) {
    let ids = keys.map(key => parseID(key));
    return Plays.getInstance().allByIds(ids);
}

export default (): MyLeaderboardLoader => ({
    playerLoader: new DataLoader<string, Player>(
        async keys => await batchPlayers(keys)
    ),
    gameLoader: new DataLoader<string, Game>(
        async keys => await batchGames(keys)
    ),
    playLoader: new DataLoader<string, Play>(
        async keys => await batchPlays(keys)
    ),
});
