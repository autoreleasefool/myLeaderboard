import React from 'react';
import RefreshView from './components/Refresh';
import GameDashboard from './dashboard/GameDashboard';
import { allGames } from './lib/Game';

interface State {
    games: Array<string>;
}

class App extends React.Component<{}, State> {
    constructor(props: {}) {
        super(props);
        this.state = {
            games: [],
        };
    }

    public componentDidMount() {
        allGames().then(games => {
            this.setState({ games });
        });
    }

    public render() {
        return (
            <div>
                <RefreshView refreshTime={20 * 1000} />
                {this.state.games.map(game => {
                    return <GameDashboard key={game} game={game} />;
                })}
            </div>
        );
    }
}

export default App;
