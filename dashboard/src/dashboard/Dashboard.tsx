import React from 'react';
import RefreshView from '../components/Refresh';
import { allGames } from '../game/Game';
import { Player } from '../lib/utils/Octo';
import './Dashboard.css';
import Limbo from './limbo/Limbo';
import ShadowRealm from './shadowRealm/ShadowRealm';
import Standings from './Standings';

interface Props {
    players: Array<Player>;
}

class Dashboard extends React.Component<Props> {
    public render() {
        return (
            <div>
                <RefreshView refreshTime={20 * 1000} />
                {allGames().map(game => {
                    return <Standings key={game} game={game} players={this.props.players} />;
                })}
                <Limbo />
                <ShadowRealm />
            </div>
        );
    }
}

export default Dashboard;
