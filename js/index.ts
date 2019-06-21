import { Game, fetchStandings } from "./standings";
import { fetchPlayers, Player } from "./player";
import { GameStandings } from "./gameStandings";
import { Octo } from "./octo";
import { User } from "./types";

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

function updateAvatars() {
    for (let player of players) {
        Octo.user(player.username.substr(1))
            .then(user => {
                updateAvatar(user);
            })
    }
}

function updateAvatar(user: User) {
    let nameRegex = new RegExp(`@${user.login}`, "gi")
    document.body.innerHTML = document.body.innerHTML.replace(nameRegex, `<img class="avatar" src="${user.avatarUrl}" />`)
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
}
