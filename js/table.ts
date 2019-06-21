import { Game, Standings, Player, Record } from "./standings";
import { VERSION } from "./versioning";

export function buildStandingsTable(game: Game, standings: Standings): string {
    return `
    <div class="standings-table">
        <div class="Polaris-Page">
            ${buildStandingsTableTitle(game)}
            <div class="Polaris-Page__Content">
                <div class="Polaris-Card">
                    <div class="">
                        <div class="Polaris-DataTable">
                            <table class="Polaris-DataTable__Table">
                                ${buildStandingsTableHeader(standings)}
                                ${buildStandingsTableBody(standings)}
                            </table>
                        </div>
                    </div>
                </div>
        </div>
    </div>
    `;
}

function buildStandingsTableTitle(game: Game): string {
    return `
    <div class="Polaris-Page-Header">
        <div class="Polaris-Page-Header__TitleAndRollup">
            <div class="Polaris-Page-Header__Title">
                <div>
                    <h1 class="Polaris-DisplayText Polaris-DisplayText--sizeLarge">${game}</h1>
                </div>
            </div>
        </div>
    </div>`;
}

function buildStandingsTableHeader(standings: Standings): string {
    function buildCell(content, isTotal: boolean = false): string {
        return `<th data-polaris-header-cell="true" class="Polaris-DataTable__Cell Polaris-DataTable__Cell--header${isTotal ? " player-record--total" : ""}" scope="col">${content}</th>`;
    }

    let header = "<thead>";
    header += buildCell(`${VERSION}`);
    header += buildCell("Total", true);

    for (let player of standings.playerNames) {
        header += buildCell(player);
    }

    header += "</thead>";
    return header;
}

function buildStandingsTableBody(standings: Standings): string {
    let body = "<tbody>";

    for (let player of standings.playerNames) {
        body += buildStandingsTableRow(player, standings);
    }

    body += "</tbody>";
    return body;
}

function buildStandingsTableRow(playerName: string, standings: Standings): string {
    function buildCell(content: string, best: boolean = false, worst: boolean = false, isTotal: boolean = false): string {
        return `<td class="Polaris-DataTable__Cell${best ? " player-record--best" : ""}${worst ? " player-record--worst" : ""}${isTotal ? " player-record--total" : ""}">${content}</td>`;
    }

    let row = `<tr class="Polaris-DataTable__TableRow">`;
    row += buildCell(playerName);

    let playerRecord = standings.playerRecords.get(playerName);
    row += buildCell(formatRecord(playerRecord), playerRecord.isBest, playerRecord.isWorst, true);

    for (let opponent of standings.playerNames) {
        if (playerName == opponent) {
            row += buildCell("--");
        }

        let recordAgainstOpponent = standings.records.get(playerName).get(opponent);
        if (recordAgainstOpponent != null) {
            row += buildCell(formatRecord(recordAgainstOpponent), recordAgainstOpponent.isBest, recordAgainstOpponent.isWorst);
        }
    }

    row += "</tr>";
    return row;
}

function formatRecord(record: Record): string {
    let format = `<span class="record--value record--wins">${record.wins}</span>-<span class="record--value record--losses">${record.losses}</span>`;
    if (record.ties > 0) {
        format += `-<span class="record--value record--ties">${record.ties}</span>`;
    }
    return format;
}
