import { Card, ColumnContentType, DataTable, Page } from '@shopify/polaris';
import React, { ReactNode } from 'react';
import PlayerView from '../components/PlayerView';
import Version from '../components/Version';
import { Game, GameStandings, Player, Record } from '../lib/types';
import { isBanished } from './shadowRealm/ShadowRealm';
import './Standings.css';

interface RecordHighlight {
    player: number | undefined;
    winRate: number;
    losses: number;
    wins: number;
}

interface Props {
    game: Game;
    standings: GameStandings;
    players: Array<Player>;
}

interface State {
    banishedPlayers: Set<number>;
    parsedStandings: GameStandings | undefined;
}

class Standings extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            banishedPlayers: new Set(),
            parsedStandings: undefined,
        };
    }

    public componentDidMount() {
        this._parseStandings();
    }

    public componentDidUpdate(prevProps: Props) {
        if (this.props.standings !== prevProps.standings) {
            this._parseStandings();
        }
    }

    public render() {
        const { game, players, standings } = this.props;

        return (
            <Page title={game.name}>
                <Card>
                    <DataTable
                        columnContentTypes={players.map(_ => 'text' as ColumnContentType)}
                        headings={[]}
                        rows={[
                            [<Version />, 'Total', ...players.map(player => <PlayerView player={player} record={standings[player.id]} />)],
                            ...players.map(player => {
                                const recordCells: Array<ReactNode> = [];
                                for (const opponent of players) {
                                    if (opponent.username === player.username) {
                                        recordCells.push('—');
                                        continue;
                                    }

                                    const record = standings[player.id].record[opponent.id];
                                    if (record == null) {
                                        recordCells.push(this._formatRecord({ wins: 0, losses: 0, ties: 0 }, false));
                                        continue;
                                    }

                                    recordCells.push(this._formatRecord(record, false));
                                }

                                return [
                                    <PlayerView key={player.username} player={player} record={standings[player.id]} />,
                                    this._formatRecord(standings[player.id].overallRecord, true),
                                    ...recordCells,
                                ];
                            }),
                        ]}
                    />
                </Card>
            </Page>
        );
    }

    private _parseStandings() {
        const banishedPlayers = this._identifyBanishedPlayers(this.props.standings, this.props.players);
        const parsedStandings = this._highlightRecords(this.props.standings);
        this.setState({ banishedPlayers, parsedStandings });
    }

    private _identifyBanishedPlayers(standings: GameStandings, players: Array<Player>): Set<number> {
        return new Set(players.filter(player => isBanished(standings[player.id])).map(player => player.id));
    }

    private _highlightRecords(originalStandings: GameStandings): GameStandings {
        const standings: GameStandings = JSON.parse(JSON.stringify(originalStandings));
        const worstRecords: Array<RecordHighlight> = [{ player: undefined, winRate: Infinity, losses: 0, wins: 0 }];
        const bestRecords: Array<RecordHighlight> = [{ player: undefined, winRate: -Infinity, losses: 0, wins: 0 }];

        for (const playerId in standings) {
            if (standings.hasOwnProperty(playerId) === false || typeof(playerId) !== 'number') {
                continue;
            }
            const player = standings[playerId];
            const totalGames = player.overallRecord.wins + player.overallRecord.losses + player.overallRecord.ties;
            const winRate = player.overallRecord.wins / totalGames;

            const playerRecordForHighlight = { player: playerId, winRate, losses: player.overallRecord.losses, wins: player.overallRecord.wins };
            this._updateHighlightedRecords(playerRecordForHighlight, bestRecords, worstRecords);

            const worstVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: Infinity, losses: 0, wins: 0 }];
            const bestVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: -Infinity, losses: 0, wins: 0 }];
            for (const oppId in player.record) {
                if (player.record.hasOwnProperty(oppId) === false) {
                    continue;
                }

                const opponentId = typeof(oppId) === 'number' ? oppId : parseInt(oppId, 10);
                const vsRecord = player.record[opponentId];
                const vsTotalGames = vsRecord.wins + vsRecord.losses + vsRecord.ties;
                const vsWinRate = vsRecord.wins / vsTotalGames;

                const vsRecordForHighlight = { player: opponentId, winRate: vsWinRate, losses: vsRecord.losses, wins: vsRecord.wins };
                this._updateHighlightedRecords(vsRecordForHighlight, bestVsRecords, worstVsRecords);
            }

            const playerVs: Map<number, Record> = new Map();
            for (const oppId in player.record) {
                if (player.record.hasOwnProperty(oppId)) {
                    const opponentId = typeof(oppId) === 'number' ? oppId : parseInt(oppId, 10);
                    playerVs.set(opponentId, player.record[opponentId]);
                }
            }

            this._markBestAndWorstRecords(playerVs, bestVsRecords, worstVsRecords);
        }

        const playerTotals: Map<number, Record> = new Map();
        for (const playerId in standings) {
            if (standings.hasOwnProperty(playerId) && typeof(playerId) === 'number') {
                playerTotals.set(playerId, standings[playerId].overallRecord);
            }
        }
        this._markBestAndWorstRecords(playerTotals, bestRecords, worstRecords);

        return standings;
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

    private _markBestAndWorstRecords(records: Map<number, Record>, bestRecords: Array<RecordHighlight>, worstRecords: Array<RecordHighlight>) {
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
