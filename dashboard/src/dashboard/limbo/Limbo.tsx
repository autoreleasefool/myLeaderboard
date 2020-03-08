import { Page } from '@shopify/polaris';
import React from 'react';
import PlayerView from '../../components/PlayerView';
import { freshness } from '../../lib/Freshness';
import { GameRecord, Player } from '../../lib/types';
import './Limbo.css';

interface Props {
    players: Player[];
    standings: GameRecord;
    forceRefresh: boolean;
}

interface State {
    limboing: Player[];
}

class Limbo extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            limboing: [],
        };
    }

    public componentDidMount(): void {
        const { players, standings } = this.props;

        const limboing = players.filter(player => {
            const playerRecord = standings.records[player.id];
            if (playerRecord == null) {
                return false;
            }

            const fresh = freshness(playerRecord);
            return fresh > 0 && fresh < 0.2;
        });

        this.setState({ limboing });
    }

    public render(): React.ReactNode {
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
