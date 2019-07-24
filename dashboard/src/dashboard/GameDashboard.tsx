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
    standings: GameStandings | undefined;
}

class Dashboard extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            standings: undefined,
        };
    }

    public componentDidMount() {
        this._fetchStandings();
    }

    public render() {
        const { standings } = this.state;
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
                <Standings key={game.id} game={game} standings={standings} players={playersWithGames} />
                <Limbo standings={standings} players={playersWithGames} />
                <ShadowRealm standings={standings} players={playersWithGames} />
            </div>
        );
    }

    private async _fetchStandings() {
        const standings = await LeaderboardAPI.getInstance().gameStandings(this.props.game.id);

        this.setState({
            standings,
        });
    }
}

export default Dashboard;
