import { Game, GameStandings, Player } from '../lib/types';

class LeaderboardAPI {
    public static getInstance(): LeaderboardAPI {
        if (LeaderboardAPI.instance == null) {
            LeaderboardAPI.instance = new LeaderboardAPI();
        }

        return LeaderboardAPI.instance;
    }

    private static instance: LeaderboardAPI;
    private static baseURL = '';

    private constructor() {}

    public async games(): Promise<Array<Game>> {
        const response = await fetch(`${LeaderboardAPI.baseURL}/games/list`);
        const gameList = await response.json();
        return gameList;
    }

    public async players(): Promise<Array<Player>> {
        const response = await fetch(`${LeaderboardAPI.baseURL}/players/list?includeAvatars=true`);
        const playerList = await response.json();
        return playerList;
    }

    public async gameStandings(id: number): Promise<GameStandings> {
        const response = await fetch(`${LeaderboardAPI.baseURL}/games/standings/${id}`);
        const standings = await response.json();
        return standings;
    }

    public async hasUpdates(since: Date): Promise<boolean> {
        const response = await fetch(`${LeaderboardAPI.baseURL}/misc/hasUpdates?since=${since.toISOString()}`);
        const updates = await response.json();
        return updates.hasUpdates;
    }
}

export default LeaderboardAPI;
