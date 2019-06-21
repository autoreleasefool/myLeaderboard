import { Player } from "./player";

export class ShadowRealm {
    private banishedPlayers: Array<Player>;

    constructor(banishedPlayers: Array<Player>) {
        this.banishedPlayers = banishedPlayers;
    }

    build(): string {
        return `
        <div class="Polaris-Page">
            ${this.buildTitle()}
            <div class="Polaris-Page__Content">
                <div class="shadow-realm-tombstones">
                    ${this.buildTombstones()}
                </div>
            </div>
        </div>
        `;
    }

    private buildTitle() {
        return `
        <div class="Polaris-Page-Header">
            <div class="Polaris-Page-Header__TitleAndRollup">
                <div class="Polaris-Page-Header__Title">
                    <div>
                        <h1 class="Polaris-DisplayText Polaris-DisplayText--sizeLarge">Shadow Realm</h1>
                    </div>
                </div>
            </div>
        </div>`;
    }

    private buildTombstones() {
        let tombstones = "";

        for (let player of this.banishedPlayers) {
            tombstones += player.renderTombstone();
        }

        return tombstones;
    }
}