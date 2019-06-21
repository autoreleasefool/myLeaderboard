import { Game, Standings, Player, Record } from "./standings";
import { VERSION } from "./versioning";

function formatRecord(record: Record): string {
    let format = `<span class="record--value record--wins">${record.wins}</span>-<span class="record--value record--losses">${record.losses}</span>`;
    if (record.ties > 0) {
        format += `-<span class="record--value record--ties">${record.ties}</span>`;
    }
    return format;
}

export class GameStandings {
    private game: Game;
    private standings: Standings;
    private players: Array<Player>

    constructor(game: Game, standings: Standings, players: Array<Player>) {
        this.game = game;
        this.standings = standings;
        this.players = players;
    }



    buildTable(): string {
        return `
        <div class="standings-table">
            <div class="Polaris-Page">
                ${this.buildStandingsTableTitle()}
                <div class="Polaris-Page__Content">
                    <div class="Polaris-Card">
                        <div class="">
                            <div class="Polaris-DataTable">
                                <table class="Polaris-DataTable__Table">
                                    ${this.buildStandingsTableHeader()}
                                    ${this.buildStandingsTableBody()}
                                </table>
                            </div>
                        </div>
                    </div>
            </div>
        </div>
        `;
    }

    private buildStandingsTableTitle(): string {
        return `
        <div class="Polaris-Page-Header">
            <div class="Polaris-Page-Header__TitleAndRollup">
                <div class="Polaris-Page-Header__Title">
                    <div>
                        <h1 class="Polaris-DisplayText Polaris-DisplayText--sizeLarge">${this.game}</h1>
                    </div>
                </div>
            </div>
        </div>`;
    }

    private buildStandingsTableHeader(): string {
        function buildCell(content, isTotal: boolean = false): string {
            return `<th data-polaris-header-cell="true" class="Polaris-DataTable__Cell Polaris-DataTable__Cell--header${isTotal ? " player-record--total" : ""}" scope="col">${content}</th>`;
        }

        let header = "<thead>";
        header += buildCell(`${VERSION}`);
        header += buildCell("Total", true);

        for (let player of this.standings.playerNames) {
            header += buildCell(player);
        }

        header += "</thead>";
        return header;
    }

    private buildStandingsTableBody(): string {
        let body = "<tbody>";

        for (let player of this.standings.playerNames) {
            body += this.buildStandingsTableRow(player);
        }

        body += "</tbody>";
        return body;
    }

    private buildStandingsTableRow(playerName: string): string {
        function buildCell(content: string, best: boolean = false, worst: boolean = false, isTotal: boolean = false): string {
            return `<td class="Polaris-DataTable__Cell${best ? " player-record--best" : ""}${worst ? " player-record--worst" : ""}${isTotal ? " player-record--total" : ""}">${content}</td>`;
        }

        let row = `<tr class="Polaris-DataTable__TableRow">`;
        row += buildCell(playerName);

        let playerRecord = this.standings.playerRecords.get(playerName);
        row += buildCell(formatRecord(playerRecord), playerRecord.isBest, playerRecord.isWorst, true);

        for (let opponent of this.standings.playerNames) {
            if (playerName == opponent) {
                row += buildCell("--");
            }

            let recordAgainstOpponent = this.standings.records.get(playerName).get(opponent);
            if (recordAgainstOpponent != null) {
                row += buildCell(formatRecord(recordAgainstOpponent), recordAgainstOpponent.isBest, recordAgainstOpponent.isWorst);
            }
        }

        row += "</tr>";
        return row;
    }
}
