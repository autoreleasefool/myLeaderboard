import React from 'react';
import { freshness } from '../lib/Freshness';
import { Player, PlayerRecord } from '../lib/types';
import './PlayerView.css';

interface Props {
    player: Player;
    record?: PlayerRecord;
    banished?: boolean;
    limbo?: boolean;
}

function PlayerView(props: Props) {
    const { player, record, banished, limbo } = props;
    let fresh: number;
    if (banished || limbo) {
        fresh = 1;
    } else if (record != null) {
        fresh = freshness(record);
    } else {
        fresh = 1;
    }

    return <img
        src={player.avatar}
        alt={player.displayName}
        className='avatar'
        style={{ opacity: fresh }}
        />;
}

export default PlayerView;
