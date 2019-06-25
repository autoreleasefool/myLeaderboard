import { Octo } from "./octo";

export interface BasicPlayer {
    username: string;
    name: string;
    graveyard?: boolean;
}

export function basicPlayerSort(first: BasicPlayer, second: BasicPlayer): number {
    return first.name.toLowerCase().localeCompare(second.name.toLowerCase())
}

export async function fetchPlayers(): Promise<Array<Player>> {
    let rawPlayers = await Octo.contents("players.json");
    let basicPlayers = parseRawPlayers(rawPlayers);
    let avatars: Map<string, string> = new Map();
    for (let player of basicPlayers) {
        let user = await Octo.user(player.username);
        avatars.set(player.username, user.avatarUrl);
    }
    return basicPlayers.map(player => new Player(player.username, player.name, avatars.get(player.username), player.graveyard === true))
}

function parseRawPlayers(contents: string): Array<BasicPlayer> {
    let players: Array<BasicPlayer> = JSON.parse(contents);
    players.sort(basicPlayerSort);
    return players
}

export class Player {
    username: string;
    displayName: string;
    avatar: string;
    banished: boolean

    constructor(username: string, name: string, avatar: string, banished: boolean = false) {
        this.username = username;
        this.displayName = name;
        this.avatar = avatar;
        this.banished = banished;
    }

    renderAvatar(): string {
        return `<img class="avatar" alt="${this.displayName}" src="${this.avatar}" />`
    }

    renderTombstone(): string {
        return `<img class="avatar tombstone" alt="${this.displayName}" src="${this.avatar}" />`
    }
}
