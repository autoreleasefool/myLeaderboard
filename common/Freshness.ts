import { PlayerRecord } from './types';

export function freshness(record: PlayerRecord): number {
    const today = new Date();
    const seconds = (today.getTime() - new Date(record.lastPlayed).getTime()) / 1000;
    const daysSinceLastPlayed = Math.floor(seconds / 86400);
    const veryFreshLimit = 7;
    const staleLimit = 21;

    if (daysSinceLastPlayed <= veryFreshLimit) {
        // Played in last X days? Very fresh.
        return 1;
    } else if (daysSinceLastPlayed >= staleLimit) {
        // Haven't played in Y days? Stale.
        return 0;
    } else {
        // Otherwise, freshness is 0-1, based on number of days
        const maxFreshnessRange = staleLimit - veryFreshLimit;
        return Math.max(0, Math.min((maxFreshnessRange - (daysSinceLastPlayed - veryFreshLimit)) / maxFreshnessRange, 1));
    }
}

export function isBanished(player: PlayerRecord): boolean {
    return freshness(player) === 0;
}
