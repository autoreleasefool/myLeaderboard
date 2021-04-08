import Games from '../db/games';
import Players from '../db/players';
import Plays from '../db/plays';
import DataLoader from 'dataloader';
import Boards from '../db/boards';
import { Player, Game, Play, Board } from '../lib/types';

export interface MyLeaderboardLoader {
    boardLoader: DataLoader<number, Board>;
    playerLoader: DataLoader<number, Player>;
    gameLoader: DataLoader<number, Game>;
    playLoader: DataLoader<number, Play>;
}

async function batchBoards(keys: readonly number[]): Promise<Array<Board>> {
    return Boards.getInstance().allByIds(keys);
}

async function batchPlayers(keys: readonly number[]): Promise<Array<Player>> {
    return Players.getInstance().allByIdsWithAvatars(keys);
}

async function batchGames(keys: readonly number[]): Promise<Array<Game>> {
    return Games.getInstance().allByIdsWithImages(keys);
}

async function batchPlays(keys: readonly number[]): Promise<Array<Play>> {
    return Plays.getInstance().allByIds(keys);
}

export default (): MyLeaderboardLoader => ({
    boardLoader: new DataLoader<number, Board>(
        async keys => await batchBoards(keys)
    ),
    playerLoader: new DataLoader<number, Player>(
        async keys => await batchPlayers(keys)
    ),
    gameLoader: new DataLoader<number, Game>(
        async keys => await batchGames(keys)
    ),
    playLoader: new DataLoader<number, Play>(
        async keys => await batchPlays(keys)
    ),
});
