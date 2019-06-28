import React from 'react';
import { Player } from '../utils/Octo';
import { allGames } from '../game/Game';
import Standings from './Standings';
import './Dashboard.css';

interface Props {
    players: Array<Player>;
}

class Dashboard extends React.Component<Props> {
    render() {
        return (
            <div>
                {allGames().map(game => {
                    return <Standings key={game} game={game} players={this.props.players} />;
                })}
                {/* <ShadowRealm></ShadowRealm> */}
            </div>
        );
    }
}

export default Dashboard;
