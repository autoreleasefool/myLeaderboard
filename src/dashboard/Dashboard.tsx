import React from 'react';
import { allGames } from '../game/Game';
import { Player } from '../utils/Octo';
import './Dashboard.css';
import Standings from './Standings';

interface Props {
    players: Array<Player>;
}

class Dashboard extends React.Component<Props> {
    public render() {
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
