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

function updateAvatars() {
    fetchPlayers()
        .then(players => {
            for (let player of players) {
                Octo.user(player.username.substr(1))
                    .then(user => {
                        updateAvatar(user);
                    })
            }
        });
}

function updateAvatar(user: User) {
    let nameRegex = new RegExp(`@${user.login}`, "gi")
    document.body.innerHTML = document.body.innerHTML.replace(nameRegex, `<img class="avatar" src="${user.avatarUrl}" />`)
}

window.onload = () => {
    let standingsPromises: Array<Promise<any>> = [];
    for (let gameName in Game) {
        const game = gameName as Game;
        standingsPromises.push(fetchStandings(game)
            .then((standings) => {
                standingsTables.set(game, buildStandingsTable(game, standings));
                renderStandings();
            }));
    }

    Promise.all(standingsPromises)
        .then(updateAvatars)


}
