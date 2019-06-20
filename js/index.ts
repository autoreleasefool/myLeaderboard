import { Game, fetchStandings, Standings, Player, formatRecord } from './standings';

let standingsTables: Map<Game, string> = new Map();

function buildStandingsTable(game: Game, standings: Standings): string {
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
    function buildCell(content): string {
        return `<th data-polaris-header-cell="true" class="Polaris-DataTable__Cell Polaris-DataTable__Cell--header" scope="col">${content}</th>`;
    }

    let header = "<thead>";
    header += buildCell("");
    header += buildCell("Total");

    for (let player of standings.players) {
        header += buildCell(player);
    }

    header += "</thead>";
    return header;
}

function buildStandingsTableBody(standings: Standings): string {
    let body = "<tbody>";

    for (let player of standings.players) {
        body += buildStandingsTableRow(player, standings);
    }

    body += "</tbody>";
    return body;
}

function buildStandingsTableRow(player: Player, standings: Standings): string {
    function buildCell(content: string): string {
        return `<td class="Polaris-DataTable__Cell">${content}</td>`;
    }

    let row = `<tr class="Polaris-DataTable__TableRow">`;
    row += buildCell(player);
    row += buildCell(formatRecord(standings.playerRecords.get(player)));

    for (let opponent of standings.players) {
        if (player == opponent) {
            row += buildCell("--");
        }

        let recordAgainstOpponent = standings.records.get(player).get(opponent);
        if (recordAgainstOpponent != null) {
            row += buildCell(formatRecord(recordAgainstOpponent));
        }
    }

    row += "</tr>";
    return row;
}

function renderStandings() {
    let standings = "";
    let games = Array.from(standingsTables.keys()).sort();
    for (let game of games) {
        standings += standingsTables.get(game as Game);
    }

    document.querySelector(".standings").innerHTML = standings;
}

window.onload = () => {
    for (let gameName in Game) {
        const game = gameName as Game;
        fetchStandings(game)
            .then((standings) => {
                standingsTables.set(game, buildStandingsTable(game, standings));
                renderStandings();
            })
    }
}
