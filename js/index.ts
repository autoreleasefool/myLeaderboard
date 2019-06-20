import { Game, fetchStandings, Standings, Player } from './standings';

let standingsTables: Map<Game, string> = new Map();

function buildStandingsTable(game: Game, standings: Standings): string {
    return `
    <div class="standings-table">
        <div class="Polaris-Page">
            ${buildStandingsTableHeader(game)}
        </div>
    </div>
    `;
}

function buildStandingsTableHeader(game: Game): string {
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

// function buildStandingsTableRows(standings: Standings): string {

// }

// function buildStandingsTableRow(player: Player, standings: Standings): string {

// }

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
