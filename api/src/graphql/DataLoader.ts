import Games from '../db/games';
import Players from '../db/players';
import Plays from '../db/plays';
import DataLoader from 'dataloader';
import { PlayerNext, GameNext, PlayNext } from '../lib/types';

export interface MyLeaderboardLoader {
    playerLoader: DataLoader<number, PlayerNext>;
    gameLoader: DataLoader<number, GameNext>;
    playLoader: DataLoader<number, PlayNext>;
}

async function batchPlayers(keys: readonly number[]): Promise<Array<PlayerNext>> {
    return Players.getInstance().allByIdsWithAvatars(keys);
}

async function batchGames(keys: readonly number[]): Promise<Array<GameNext>> {
    return Games.getInstance().allByIdsWithImages(keys);
}

async function batchPlays(keys: readonly number[]): Promise<Array<PlayNext>> {
    return Plays.getInstance().allByIds(keys);
}

export default (): MyLeaderboardLoader => ({
    playerLoader: new DataLoader<number, PlayerNext>(
        async keys => await batchPlayers(keys)
    ),
    gameLoader: new DataLoader<number, GameNext>(
        async keys => await batchGames(keys)
    ),
    playLoader: new DataLoader<number, PlayNext>(
        async keys => await batchPlays(keys)
    ),
});
