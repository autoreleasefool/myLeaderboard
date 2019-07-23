import React from 'react';
import LeaderboardAPI from './api/LeaderboardAPI';
import RefreshView from './components/Refresh';
import GameDashboard from './dashboard/GameDashboard';
import { Game } from './lib/types';

interface State {
    games: Array<Game>;
}

class App extends React.Component<{}, State> {
    constructor(props: {}) {
        super(props);
        this.state = {
            games: [],
        };
    }

    public componentDidMount() {
        LeaderboardAPI.getInstance().games().then(games => {
            this.setState({ games });
        });
    }

    public render() {
        return (
            <div>
                <RefreshView refreshTime={20 * 1000} />
                {this.state.games.map(game => {
                    return <GameDashboard key={game.id} game={game} />;
                })}
            </div>
        );
    }
}

export default App;
