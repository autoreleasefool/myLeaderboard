import { Page } from '@shopify/polaris';
import React from 'react';
import PlayerView from '../../components/PlayerView';
import Octo, { Player } from '../../utils/Octo';
import './ShadowRealm.css';

interface State {
    banished: Array<Player>;
}

class ShadowRealm extends React.Component<{}, State> {
    constructor(props: {}) {
        super(props);
        this.state = {
            banished: [],
        };
    }

    public componentDidMount() {
        Octo.getInstance().players().then(players => {
            const banished = players.filter(player => isBanished(player));
            this.setState({ banished });
        });
    }

    public render() {
        return (
            <Page title={'Shadow Realm'}>
                <div className="shadowRealm">
                    {this.state.banished.map(player => <PlayerView key={player.username} player={player} />)}
                </div>
            </Page>
        );
    }
}

function freshness(daysSinceLastPlayed: number): number {
    if (daysSinceLastPlayed < 7) {
        // Played in the last week? Very fresh.
        return 100;
    } else if (daysSinceLastPlayed > 30) {
        // Haven't played in a month? Stale.
        return 0;
    } else {
        // Otherwise, freshness is 0-100, based on number of days
        return Math.min((daysSinceLastPlayed - 7) / 23 * 100, 100);
    }
}

export function lastPlayedFade(player: Player): number {
    const today = new Date();
    const seconds = (today.getTime() - player.lastPlayed.getTime()) / 1000;
    const daysSince = Math.floor(seconds / 86400);
    return freshness(daysSince);
}

export function isBanished(player: Player): boolean {
    return lastPlayedFade(player) === 0;
}

export default ShadowRealm;
