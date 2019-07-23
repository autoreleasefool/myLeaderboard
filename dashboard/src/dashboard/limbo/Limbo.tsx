import { Page } from '@shopify/polaris';
import React from 'react';
import PlayerView from '../../components/PlayerView';
import { GameStandings, Player } from '../../lib/types';
import { freshness } from '../shadowRealm/ShadowRealm';
import './Limbo.css';

interface Props {
    players: Array<Player>;
    standings: GameStandings;
}

interface State {
    limboing: Array<Player>;
}

class Limbo extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            limboing: [],
        };
    }

    public componentDidMount() {
        const { players, standings } = this.props;

        const limboing = players.filter(player => {
            const playerRecord = standings[player.id];
            if (playerRecord == null) {
                return false;
            }

            const fresh = freshness(playerRecord);
            return fresh > 0 && fresh < 0.2;
        });

        this.setState({ limboing });
    }

    public render() {
        const { limboing } = this.state;
        if (limboing.length === 0) {
            return null;
        }

        return (
            <Page title={'Limbo'}>
                <div className={'limbo'}>
                    {this.state.limboing.map(player => <PlayerView key={player.username} player={player} limbo={true} />)}
                </div>
            </Page>
        );
    }
}

export default Limbo;
