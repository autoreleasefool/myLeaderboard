import React from 'react';
import { freshness } from '../dashboard/shadowRealm/ShadowRealm';
import { Player } from '../utils/Octo';
import './PlayerView.css';

interface Props {
    player: Player;
    banished?: boolean;
    limbo?: boolean;
}

function PlayerView(props: Props) {
    const { player } = props;
    let fresh: number;
    if (props.banished || props.limbo) {
        fresh = 1;
    } else {
        fresh = freshness(player);
    }

    return <img
        src={player.avatar}
        alt={player.displayName}
        className='avatar'
        style={{ opacity: fresh }}
        />;
}

export default PlayerView;
