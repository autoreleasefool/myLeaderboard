import { Card, ColumnContentType, DataTable, Page } from '@shopify/polaris';
import React, { ReactNode } from 'react';
import PlayerView from '../components/PlayerView';
import Version from '../components/Version';
import { Game, GameStandings, Player, Record } from '../lib/types';
import { isBanished } from './shadowRealm/ShadowRealm';
import './Standings.css';

interface Props {
    game: Game;
    standings: GameStandings;
    players: Array<Player>;
}

interface State {
    banishedPlayers: Set<number>;
}

class Standings extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            banishedPlayers: new Set(),
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

        const visiblePlayers = players.filter(player => this.state.banishedPlayers.has(player.id) === false);

        return (
            <Page title={game.name}>
                <Card>
                    <DataTable
                        columnContentTypes={visiblePlayers.map(_ => 'text' as ColumnContentType)}
                        headings={[]}
                        rows={[
                            [<Version />, 'Total', ...visiblePlayers.map(player => <PlayerView player={player} record={standings[player.id]} />)],
                            ...visiblePlayers.map(player => {
                                const recordCells: Array<ReactNode> = [];
                                for (const opponent of visiblePlayers) {
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
        const { players, standings } = this.props;
        const banishedPlayers = this._identifyBanishedPlayers(standings, players);
        this.setState({ banishedPlayers });
    }

    private _identifyBanishedPlayers(standings: GameStandings, players: Array<Player>): Set<number> {
        return new Set(players.filter(player => isBanished(standings[player.id])).map(player => player.id));
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
