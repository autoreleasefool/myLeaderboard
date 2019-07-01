import { Page } from '@shopify/polaris';
import React from 'react';
import PlayerView from '../../components/PlayerView';
import { Player } from '../../lib/types';
import { freshness } from '../shadowRealm/ShadowRealm';
import './Limbo.css';

interface Props {
    players: Array<Player>;
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
        const limboing = this.props.players.filter(player => {
            const fresh = freshness(player);
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
