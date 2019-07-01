import React from 'react';
import RefreshView from './components/Refresh';
import GameDashboard from './dashboard/GameDashboard';
import { allGames } from './lib/Game';

function App(): React.ReactElement {
    return (
        <div>
            <RefreshView refreshTime={20 * 1000} />
            {allGames().map(game => {
                return <GameDashboard key={game} game={game} />;
            })}
        </div>
    );
}

export default App;
