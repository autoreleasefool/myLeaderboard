import React from 'react';
import LeaderboardAPI from '../api/LeaderboardAPI';
import { Game, GameStandings, Player } from '../lib/types';
import './GameDashboard.css';
import Limbo from './limbo/Limbo';
import ShadowRealm from './shadowRealm/ShadowRealm';
import Standings from './Standings';

interface Props {
    game: Game;
    players: Array<Player>;
}

interface State {
    refresh: boolean;
    standings: GameStandings | undefined;
}

const softRefreshTime = 60 * 60 * 1000;

class Dashboard extends React.Component<Props, State> {
    private refreshInterval: number | undefined = undefined;

    constructor(props: Props) {
        super(props);
        this.state = {
            refresh: false,
            standings: undefined,
        };
    }

    public componentDidMount() {
        this._fetchStandings();
        this._startRefreshLoop();
    }

    public render() {
        const { refresh, standings } = this.state;
        const { game, players } = this.props;

        if (standings == null || players.length === 0) {
            return null;
        }

        const playersWithGames = players.filter(player => {
            const playerRecord = standings.records[player.id];
            if (playerRecord == null) {
                return false;
            }

            const { wins, losses, ties } = playerRecord.overallRecord;
            return (wins > 0 || losses > 0 || ties > 0);
        });

        return (
            <div className={'game-dashboard'}>
                <Standings key={game.id} game={game} standings={standings} players={playersWithGames} forceRefresh={refresh} />
                <Limbo standings={standings} players={playersWithGames} forceRefresh={refresh} />
                <ShadowRealm standings={standings} players={playersWithGames} forceRefresh={refresh} />
            </div>
        );
    }

    private async _fetchStandings() {
        const standings = await LeaderboardAPI.getInstance().gameStandings(this.props.game.id);

        this.setState({
            standings,
        });
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
