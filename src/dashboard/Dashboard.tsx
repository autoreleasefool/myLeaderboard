import React from 'react';
import { Player } from '../utils/Octo';
import { allGames } from '../game/Game';
import Standings from './Standings';
import './Dashboard.css';

interface Props {
    players: Array<Player>;
}

function Dashboard(props: Props) {
    return (
        <div>
            {allGames().map(game => {
                return <Standings game={game} players={props.players} />;
            })}
            {/* <ShadowRealm></ShadowRealm> */}
        </div>
    );
}

export default Dashboard;
