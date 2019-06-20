import { Game, fetchStandings, fetchPlayers } from "./standings";
import { buildStandingsTable } from "./table";

let standingsTables: Map<Game, string> = new Map();

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
