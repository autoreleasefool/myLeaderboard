import React from 'react';
import { Game } from '../lib/Game';
import Octo from '../lib/Octo';
import { BasicGamePlayer, GameStandings, Player } from '../lib/types';
import './GameDashboard.css';
import Limbo from './limbo/Limbo';
import ShadowRealm from './shadowRealm/ShadowRealm';
import Standings from './Standings';

interface Props {
    game: Game;
}

interface State {
    standings: GameStandings | undefined;
    players: Array<Player>;
}

class Dashboard extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            players: [],
            standings: undefined,
        };
    }

    public componentDidMount() {
        this._fetchStandings();
    }

    public render() {
        const { players, standings } = this.state;
        const { game } = this.props;

        if (standings == null || players.length === 0) {
            return null;
        }

        return (
            <div>
                <Standings key={game} game={game} standings={standings} players={players} />
                <Limbo players={players} />
                <ShadowRealm players={players} />
            </div>
        );
    }

    private async _fetchStandings() {
        const contents = await Octo.getInstance().contents(`data/${this.props.game}.json`);
        const standings: GameStandings = JSON.parse(contents);
        const genericPlayers = await Octo.getInstance().players();
        const players: Array<Player> = [];

        for (const genericPlayer of genericPlayers) {
            let standingsPlayer: BasicGamePlayer | undefined;
            for (const player of standings.players) {
                if (player.username === genericPlayer.username) {
                    standingsPlayer = player;
                }
            }

            if (standingsPlayer == null) {
                continue;
            }

            players.push({
                avatar: genericPlayer.avatar,
                displayName: genericPlayer.displayName,
                lastPlayed: new Date(standingsPlayer.lastPlayed),
                username: genericPlayer.username,
            });
        }

        this.setState({
            players,
            standings,
        });
    }


}

export default Dashboard;
