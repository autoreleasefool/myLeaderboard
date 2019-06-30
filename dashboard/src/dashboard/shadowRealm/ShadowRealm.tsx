import { Page } from '@shopify/polaris';
import React from 'react';
import PlayerView from '../../components/PlayerView';
import Octo, { Player } from '../../lib/Octo';
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
                <div className={'shadowRealm'}>
                    {this.state.banished.map(player => <PlayerView key={player.username} player={player} banished={true} />)}
                </div>
            </Page>
        );
    }
}

export function freshness(player: Player): number {
    const today = new Date();
    const seconds = (today.getTime() - player.lastPlayed.getTime()) / 1000;
    const daysSinceLastPlayed = Math.floor(seconds / 86400);

    if (daysSinceLastPlayed < 7) {
        // Played in the last week? Very fresh.
        return 1;
    } else if (daysSinceLastPlayed > 30) {
        // Haven't played in a month? Stale.
        return 0;
    } else {
        // Otherwise, freshness is 0-1, based on number of days
        return Math.min((23 - (daysSinceLastPlayed - 7)) / 23, 1);

    }
}

export function isBanished(player: Player): boolean {
    return freshness(player) === 0;
}

export default ShadowRealm;
