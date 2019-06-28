import { Card, ColumnContentType, DataTable, Page } from '@shopify/polaris';
import React, { ReactNode } from 'react';
import PlayerView from '../components/PlayerView';
import Version from '../components/Version';
import { Game } from '../game/Game';
import Octo, { Player } from '../utils/Octo';
import { isBanished } from './shadowRealm/ShadowRealm';
import './Standings.css';

interface Record {
    wins: number;
    losses: number;
    ties: number;
    isBest?: boolean;
    isWorst?: boolean;
}

interface RecordHighlight {
    player: string | undefined;
    winRate: number;
    losses: number;
    wins: number;
}

interface GamePlayer {
    username: string;
    total: Record;
    records: Map<string, Record>;
}

interface JSONStandings {
    [key: string]: {
        [key: string]: Record;
    };
}

interface Props {
    game: Game;
    players: Array<Player>;
}

interface State {
    banishedPlayers: Set<string>;
    gamePlayers: Array<GamePlayer>;
}

class Standings extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            banishedPlayers: new Set(),
            gamePlayers: [],
        };
    }

    public componentDidMount() {
        this._fetchStandings(this.props.game);
    }

    public componentWillReceiveProps() {
        this._fetchStandings(this.props.game);
    }

    public render() {
        const { game, players } = this.props;
        const { gamePlayers } = this.state;
        const namesToPlayers = this._mapPlayerNamesToPlayers(players);

        return (
            <Page title={game}>
                <Card>
                    <DataTable
                        columnContentTypes={gamePlayers.map(_ => 'text' as ColumnContentType)}
                        headings={[]}
                        rows={[
                            [<Version />, 'Total', ...gamePlayers.map(player => <PlayerView player={namesToPlayers.get(player.username)!} />)],
                            ...gamePlayers.map(player => {
                                const recordCells: Array<ReactNode> = [];
                                for (const opponent of gamePlayers) {
                                    if (opponent.username === player.username) {
                                        recordCells.push('—');
                                        continue;
                                    }

                                    recordCells.push(this._formatRecord(player.records.get(opponent.username)!, false));
                                }

                                return [
                                    <PlayerView key={player.username} player={namesToPlayers.get(player.username)!} />,
                                    this._formatRecord(player.total, true),
                                    ...recordCells,
                                ];
                            }),
                        ]}
                    />
                </Card>
            </Page>
        );
    }

    private async _fetchStandings(game: Game) {
        const contents = await Octo.getInstance().contents(`standings/${game}.json`);
        const json: JSONStandings = JSON.parse(contents);
        this._parseStandings(json);
    }

    private _parseStandings(jsonStandings: JSONStandings) {
        const usernames: Array<string> = [];
        const overallRecords: Map<string, Record> = new Map();
        const headToHeadRecords: Map<string, Map<string, Record>> = new Map();

        for (const playerUsername of Object.keys(jsonStandings)) {
            usernames.push(playerUsername);
            const playerOverallRecord: Record = { wins: 0, losses: 0, ties: 0 };

            for (const opponentUsername of Object.keys(jsonStandings[playerUsername])) {
                const { wins, losses, ties } = jsonStandings[playerUsername][opponentUsername];
                if (headToHeadRecords.has(playerUsername) === false) {
                    headToHeadRecords.set(playerUsername, new Map());
                }

                const playerRecords = headToHeadRecords.get(playerUsername)!;
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
                records: headToHeadRecords.get(player.username)!,
                total: overallRecords.get(player.username)!,
                username: player.username,
            };
        }).sort((first, second) => first.username.toLowerCase().localeCompare(second.username.toLowerCase()));

        this._highlightRecords(gamePlayers);

        this.setState({
            banishedPlayers,
            gamePlayers,
        });
    }

    private _identifyInvisiblePlayers(records: Map<string, Record>): Set<string> {
        return new Set(Array.from(records.keys()).filter(player => {
            const record = records.get(player)!;
            return record.wins + record.losses + record.ties === 0;
        }));
    }

    private _identifyBanishedPlayers(players: Array<Player>): Set<string> {
        return new Set(players.filter(player => isBanished(player)).map(player => player.username));
    }

    private _highlightRecords(players: Array<GamePlayer>) {
        const worstRecords: Array<RecordHighlight> = [{ player: undefined, winRate: Infinity, losses: 0, wins: 0 }];
        const bestRecords: Array<RecordHighlight> = [{ player: undefined, winRate: -Infinity, losses: 0, wins: 0 }];

        for (const player of players) {
            const totalGames = player.total.wins + player.total.losses + player.total.ties;
            const winRate = player.total.wins / totalGames;

            const playerRecordForHighlight = { player: player.username, winRate, losses: player.total.losses, wins: player.total.wins };
            this._updateHighlightedRecords(playerRecordForHighlight, bestRecords, worstRecords);

            const worstVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: Infinity, losses: 0, wins: 0 }];
            const bestVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: -Infinity, losses: 0, wins: 0 }];
            for (const opponent of player.records.keys()) {
                const vsRecord = player.records.get(opponent)!;
                const vsTotalGames = vsRecord.wins + vsRecord.losses + vsRecord.ties;
                const vsWinRate = vsRecord.wins / vsTotalGames;

                const vsRecordForHighlight = { player: opponent, winRate: vsWinRate, losses: vsRecord.losses, wins: vsRecord.wins };
                this._updateHighlightedRecords(vsRecordForHighlight, bestVsRecords, worstVsRecords);
            }

            this._markBestAndWorstRecords(player.records, bestVsRecords, worstVsRecords);
        }

        const playerTotals: Map<string, Record> = new Map();
        for (const player of players) {
            playerTotals.set(player.username, player.total);
        }
        this._markBestAndWorstRecords(playerTotals, bestRecords, worstRecords);
    }

    private _updateHighlightedRecords(record: RecordHighlight, bestRecords: Array<RecordHighlight>, worstRecords: Array<RecordHighlight>) {
        if (record.winRate > bestRecords[0].winRate) {
            bestRecords.length = 0;
            bestRecords.push(record);
        } else if (record.winRate === bestRecords[0].winRate) {
            if (record.wins > bestRecords[0].wins) {
                bestRecords.length = 0;
                bestRecords.push(record);
            } else if (record.wins === bestRecords[0].wins) {
                bestRecords.push(record);
            }
        }

        if (record.winRate < worstRecords[0].winRate) {
            worstRecords.length = 0;
            worstRecords.push(record);
        } else if (record.winRate === worstRecords[0].winRate) {
            if (record.losses > worstRecords[0].losses) {
                worstRecords.length = 0;
                worstRecords.push(record);
            } else if (record.losses === bestRecords[0].losses) {
                worstRecords.push(record);
            }
        }
    }

    private _markBestAndWorstRecords(records: Map<string, Record>, bestRecords: Array<RecordHighlight>, worstRecords: Array<RecordHighlight>) {
        for (const player of records.keys()) {
            const playerRecord = records.get(player)!;

            for (const best of bestRecords) {
                if (best.player === player) {
                    playerRecord.isBest = true;
                    break;
                }
            }

            for (const worst of worstRecords) {
                if (worst.player === player) {
                    playerRecord.isWorst = true;
                    break;
                }
            }
        }
    }

    private _mapPlayerNamesToPlayers(players: Array<Player>): Map<string, Player> {
        const map: Map<string, Player> = new Map();
        for (const player of players) {
            map.set(player.username, player);
        }
        return map;
    }

    private _formatRecord(record: Record, overall: boolean): ReactNode {
        const classNames: Array<string> = ['record'];

        if (overall) {
            classNames.push('record--overall');
        }

        if (record.isWorst) {
            classNames.push('record--worst');
        }

        if (record.isBest) {
            classNames.push('record--best');
        }

        return (
            <div className={classNames.join(' ')}>
                <span className='record--value record--wins'>{record.wins}</span>
                {'-'}
                <span className='record--value record--losses'>{record.losses}</span>
                {record.ties > 0
                    ? (
                        <span>
                            {'-'}
                            <span className='record--value record--ties'>{record.ties}</span>
                        </span>
                    )
                    : null
                }
            </div>
        );
    }
}

export default Standings;
