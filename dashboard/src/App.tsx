import React from 'react';
import LeaderboardAPI from './api/LeaderboardAPI';
import RefreshView from './components/Refresh';
import GameDashboard from './dashboard/GameDashboard';
import { Game, Player } from './lib/types';

interface State {
    games: Array<Game>;
    players: Array<Player>;
}

class App extends React.Component<{}, State> {
    constructor(props: {}) {
        super(props);
        this.state = {
            games: [],
            players: [],
        };
    }

    public componentDidMount() {
        this._fetchData();
    }

    public render() {
        const { games, players } = this.state;

        return (
            <div>
                <RefreshView refreshTime={20 * 1000} />
                {games.map(game => {
                    return <GameDashboard key={game.id} game={game} players={players} />;
                })}
            </div>
        );
    }

    private async _fetchData() {
        const games = await LeaderboardAPI.getInstance().games();
        const players = await LeaderboardAPI.getInstance().players();
        players.sort((first, second) => first.username.toLowerCase().localeCompare(second.username.toLowerCase()));

        this.setState({ games, players });
    }
}

export default App;