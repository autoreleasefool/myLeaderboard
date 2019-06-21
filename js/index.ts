import { Game, fetchStandings } from "./standings";
import { fetchPlayers, Player } from "./player";
import { GameStandings } from "./gameStandings";
import { Octo } from "./octo";
import { User } from "./types";
import { ShadowRealm } from "./shadowRealm";

let standingsTables: Map<Game, GameStandings> = new Map();
let players: Array<Player> = [];

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

window.onload = async () => {
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
}
