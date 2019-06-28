import React from 'react';
import { Player } from '../utils/Octo';
import './PlayerView.css';

interface Props {
    player: Player;
}

export function PlayerView(props: Props) {
    const { player } = props;
    return <img src={player.avatar} alt={player.displayName} className="avatar" />;
}
