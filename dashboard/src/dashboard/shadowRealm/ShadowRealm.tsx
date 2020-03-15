import { Page } from '@shopify/polaris';
import React from 'react';
import PlayerView from '../../components/PlayerView';
import { isBanished } from '../../lib/Freshness';
import { GameRecord, Player } from '../../lib/types';
import './ShadowRealm.css';

interface Props {
    players: Player[];
    standings: GameRecord;
    forceRefresh: boolean;
}

interface State {
    banished: Player[];
}

class ShadowRealm extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            banished: [],
        };
    }

    public componentDidMount(): void {
        this._identifyBanishedPlayers();
    }

    public componentDidUpdate(prevProps: Props): void {
        if (this.props.players !== prevProps.players) {
            this._identifyBanishedPlayers();
        }
    }

    public render(): React.ReactNode {
        const { banished } = this.state;
        if (banished.length === 0) {
            return null;
        }

        return (
            <Page title={'Shadow Realm'}>
                <div className={'shadowRealm'}>
                    {this.state.banished.map(player => <PlayerView key={player.username} player={player} banished={true} />)}
                </div>
            </Page>
        );
    }

    private _identifyBanishedPlayers(): void {
        const { players, standings } = this.props;
        const banished = players.filter(player => {
            const playerRecord = standings.records[player.id];
            return playerRecord == null ? false : isBanished(playerRecord);
        });
        this.setState({ banished });
    }
}

export default ShadowRealm;
