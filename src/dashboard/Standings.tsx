import React from 'react';
import { Game } from '../game/Game';
import { Page, Card, DataTable, ColumnContentType } from '@shopify/polaris';
import Octo, { Player } from '../utils/Octo';
import { isBanished } from './shadowRealm/ShadowRealm';
import { PlayerView } from '../components/PlayerView';
import './Standings.css';

interface Record {
    wins: number;
    losses: number;
    ties: number;
    isBest?: boolean;
    isWorst?: boolean;
}

interface GamePlayer {
    username: string;
    total: Record;
    records: Map<string, Record>,
}

interface JSONStandings {
    [key: string]: {
        [key: string]: Record;
    }
}

interface Props {
    game: Game;
    players: Array<Player>;
}

interface State {
    gamePlayers: Array<GamePlayer>;
    banishedPlayers: Set<string>;
}

class Standings extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            gamePlayers: [],
            banishedPlayers: new Set(),
        };
    }

    componentDidMount() {
        this._fetchStandings(this.props.game);
    }

    componentWillReceiveProps() {
        this._fetchStandings(this.props.game);
    }

    async _fetchStandings(game: Game) {
        const contents = await Octo.getInstance().contents(`standings/${game}.json`);
        const json: JSONStandings = JSON.parse(contents);
        this._parseStandings(json);
    }

    _parseStandings(jsonStandings: JSONStandings) {
        let usernames: Array<string> = [];
        let overallRecords: Map<string, Record> = new Map();
        let headToHeadRecords: Map<string, Map<string, Record>> = new Map();

        for (let playerUsername of Object.keys(jsonStandings)) {
            usernames.push(playerUsername);
            let playerOverallRecord: Record = { wins: 0, losses: 0, ties: 0 };

            for (let opponentUsername of Object.keys(jsonStandings[playerUsername])) {
                const { wins, losses, ties } = jsonStandings[playerUsername][opponentUsername];
                if (headToHeadRecords.has(playerUsername) === false) {
                    headToHeadRecords.set(playerUsername, new Map());
                }

                let playerRecords = headToHeadRecords.get(playerUsername)!;
                playerRecords.set(opponentUsername, { wins, losses, ties });

                playerOverallRecord.wins += wins;
                playerOverallRecord.losses += losses;
                playerOverallRecord.ties += ties;
            }

            overallRecords.set(playerUsername, playerOverallRecord);
        }

        const invisiblePlayers = this._identifyInvisiblePlayers(overallRecords);
        const banishedPlayers = this._identifyBanishedPlayers(this.props.players);

        const gamePlayers: Array<GamePlayer> = this.props.players.filter(player => {
            return invisiblePlayers.has(player.username) === false && banishedPlayers.has(player.username) === false;
        }).map(player => {
            return {
                username: player.username,
                total: overallRecords.get(player.username)!,
                records: headToHeadRecords.get(player.username)!,
            };
        }).sort((first, second) => first.username.toLowerCase().localeCompare(second.username.toLowerCase()));

        this.setState({
            gamePlayers,
            banishedPlayers,
        });
    }

    _identifyInvisiblePlayers(records: Map<string, Record>): Set<string> {
        return new Set(Array.from(records.keys()).filter(player => {
            let record = records.get(player)!;
            return record.wins + record.losses + record.ties === 0;
        }));
    }

    _identifyBanishedPlayers(players: Array<Player>): Set<string> {
        return new Set(players.filter(player => isBanished(player)).map(player => player.username));
    }

    _mapPlayerNamesToPlayers(players: Array<Player>): Map<string, Player> {
        let map: Map<string, Player> = new Map();
        for (let player of players) {
            map.set(player.username, player);
        }
        return map;
    }

    _formatRecord(record: Record): string {
        return `${record.wins}-${record.losses}-${record.ties}`;
    }

    render() {
        const { game, players } = this.props;
        const { gamePlayers, banishedPlayers } = this.state;
        const namesToPlayers = this._mapPlayerNamesToPlayers(players);

        return (
            <Page title={game}>
                <Card>
                    <DataTable
                        columnContentTypes={gamePlayers.map(_ => 'text' as ColumnContentType)}
                        headings={[]}
                        rows={[
                            ['v5.0', '', ...gamePlayers.map(player => <PlayerView player={namesToPlayers.get(player.username)!} />)],
                            ...gamePlayers.map(player => {
                                let recordCells: Array<string> = [];
                                for (let opponent of gamePlayers) {
                                    if (opponent.username === player.username) {
                                        recordCells.push("--");
                                        continue;
                                    }

                                    recordCells.push(this._formatRecord(player.records.get(opponent.username)!))
                                }

                                return [
                                    <PlayerView key={player.username} player={namesToPlayers.get(player.username)!} />,
                                    this._formatRecord(player.total),
                                    ...recordCells,
                                ]
                            })
                        ]}
                    />
                </Card>
            </Page>
        );
    }
}

export default Standings;
