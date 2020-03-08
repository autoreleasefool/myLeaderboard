import React from 'react';
import { Page } from '@shopify/polaris';
import LeaderboardAPI from '../api/LeaderboardAPI';
import { Game, GameRecord, Player } from '../lib/types';
import './GameDashboard.css';
import Limbo from './limbo/Limbo';
import ShadowRealm from './shadowRealm/ShadowRealm';
import Standings from './Standings';
import { isBanished } from '../lib/Freshness';

interface Props {
    game: Game;
    players: Player[];
}

interface State {
    banishedPlayers: Set<number>;
    playersWithGames: Player[];
    refresh: boolean;
    standings: GameRecord | undefined;
}

const softRefreshTime = 60 * 60 * 1000;

class Dashboard extends React.Component<Props, State> {
    private refreshInterval: number | undefined = undefined;

    constructor(props: Props) {
        super(props);
        this.state = {
            banishedPlayers: new Set(),
            playersWithGames: [],
            refresh: false,
            standings: undefined,
        };
    }

    public componentDidMount() {
        this._fetchStandings();
        this._startRefreshLoop();
    }

    public render() {
        const { refresh, standings, playersWithGames } = this.state;
        const { game } = this.props;

        if (standings == null || playersWithGames.length === 0) {
            return null;
        }

        const visiblePlayers = playersWithGames.filter(player => this.state.banishedPlayers.has(player.id) === false);

        if (playersWithGames.length > 0 && visiblePlayers.length === 0) {
            return (
                <Page title={game.name}>
                    <h1 className={'no-recent-plays'}>No recent plays...</h1>
                </Page>
            );
        }

        return (
            <div className={'game-dashboard'}>
                <Standings key={game.id} game={game} standings={standings} players={playersWithGames} forceRefresh={refresh} />
                <Limbo standings={standings} players={playersWithGames} forceRefresh={refresh} />
                <ShadowRealm standings={standings} players={playersWithGames} forceRefresh={refresh} />
            </div>
        );
    }

    private async _fetchStandings() {
        const { players } = this.props;
        const standings = await LeaderboardAPI.getInstance().gameStandings(this.props.game.id);

        const playersWithGames = players.filter(player => {
            const playerRecord = standings.records[player.id];
            if (playerRecord == null) {
                return false;
            }

            const { wins, losses, ties } = playerRecord.overallRecord;
            return (wins > 0 || losses > 0 || ties > 0);
        });

        const banishedPlayers = this._identifyBanishedPlayers(standings, playersWithGames);

        this.setState({
            banishedPlayers,
            playersWithGames,
            standings,
        });
    }

    private _identifyBanishedPlayers(standings: GameRecord, players: Player[]): Set<number> {
        return new Set(players.filter(player => isBanished(standings.records[player.id])).map(player => player.id));
    }

    private _startRefreshLoop() {
        if (this.refreshInterval != null) {
            window.clearInterval(this.refreshInterval);
        }

        this.refreshInterval = window.setInterval(() => this._refreshLoop(), softRefreshTime);
    }

    private async _refreshLoop() {
        this.setState({ refresh: !this.state.refresh });
    }
}

export default Dashboard;
