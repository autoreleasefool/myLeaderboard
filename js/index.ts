import { Game, fetchStandings } from "./standings";
import { fetchPlayers, Player } from "./player";
import { GameStandings } from "./gameStandings";
import { ShadowRealm } from "./shadowRealm";
import { getCurrentPage } from "./utils";
import { handleApiCall } from "./api";
import { startRefreshLoop } from "./refresh";

// Routing

window.onload = () => {
    const currentPage = getCurrentPage()
    if (currentPage == "dashboard.html") {
        loadDashboard();
    } else if (currentPage == "api.html") {
        loadApi();
    }
}

// Dashboard

let standingsTables: Map<Game, GameStandings> = new Map();
let players: Array<Player> = [];

async function loadDashboard() {
    players = await fetchPlayers();

    let standingsPromises: Array<Promise<any>> = [];
    for (let gameName in Game) {
        const game = gameName as Game;
        standingsPromises.push(fetchStandings(game)
            .then((standings) => {
                standingsTables.set(game, new GameStandings(game, standings, players));
                renderStandings();
            }));
    }

    await Promise.all(standingsPromises);
    renderShadowRealm();

    startRefreshLoop();
}

function renderStandings() {
    let standings = "";
    let games = Array.from(standingsTables.keys()).sort();
    for (let game of games) {
        standings += standingsTables.get(game as Game).buildTable();
    }

    document.querySelector(".standings").innerHTML = standings;
}

function renderShadowRealm() {
    let banishedPlayers = players.filter(player => player.banished === true);
    let shadowRealm = new ShadowRealm(banishedPlayers);
    document.querySelector(".shadowRealm").innerHTML = shadowRealm.build();
}

// Api

async function loadApi() {
    handleApiCall();
}
