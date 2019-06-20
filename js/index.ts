import { Game, fetchStandings, fetchPlayers } from "./standings";
import { buildStandingsTable } from "./table";
import { Octo } from "./octo";
import { User } from "./types";

let standingsTables: Map<Game, string> = new Map();

function renderStandings() {
    let standings = "";
    let games = Array.from(standingsTables.keys()).sort();
    for (let game of games) {
        standings += standingsTables.get(game as Game);
    }

    document.querySelector(".standings").innerHTML = standings;
}

function updateAvatar(user: User) {
    let nameRegex = new RegExp(`@${user.login}`, "gi")
    document.body.innerHTML = document.body.innerHTML.replace(nameRegex, `<img class="avatar" src="${user.avatarUrl}" />`)
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

    fetchPlayers()
        .then(players => {
            for (let player of players) {
                Octo.user(player.substr(1))
                    .then(user => {
                        console.log(user);
                        updateAvatar(user);
                    })
            }
        });
}
