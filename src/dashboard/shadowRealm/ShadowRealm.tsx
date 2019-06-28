import { Player } from '../../utils/Octo';

function freshness(daysSinceLastPlayed: number): number {
    if (daysSinceLastPlayed < 7) {
        // Played in the last week? Very fresh.
        return 100;
    } else if (daysSinceLastPlayed > 30) {
        // Haven't played in a month? Stale.
        return 0;
    } else {
        // Otherwise, freshness is 0-100, based on number of days
        return Math.min((daysSinceLastPlayed - 7) / 23 * 100, 100);
    }
}

export function lastPlayedFade(player: Player): number {
    const today = new Date();
    const seconds = (today.getTime() - player.lastPlayed.getTime()) / 1000;
    const daysSince = Math.floor(seconds / 86400);
    return freshness(daysSince);
}

export function isBanished(player: Player): boolean {
    return lastPlayedFade(player) === 0;
}
