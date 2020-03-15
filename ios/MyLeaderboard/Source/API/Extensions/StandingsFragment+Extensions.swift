//
//  StandingsFragment+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-15.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation

public typealias StandingsFragment = MyLeaderboardAPI.StandingsFragment
public typealias StandingsGame = MyLeaderboardAPI.StandingsGameFragment
public typealias StandingsPlayerRecordNext = MyLeaderboardAPI.StandingsPlayerRecordFragment
public typealias StandingsPlayerGameRecord = MyLeaderboardAPI.StandingsPlayerGameRecordFragment

extension StandingsGame: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension StandingsPlayerGameRecord {
	var lastPlayedDay: Date? {
		guard let lastPlayed = self.lastPlayed else { return nil }
		let components = Calendar.current.dateComponents([.year, .month, .day], from: lastPlayed)
		return Calendar.current.date(from: components)
	}

	var isBanished: Bool {
		return freshness == 0
	}

	var freshness: Double {
		guard let lastPlayed = self.lastPlayedDay else { return 0 }
		let seconds = Date().timeIntervalSince(lastPlayed)
		let daysSinceLastPlayed = floor(seconds / 86400)

		if daysSinceLastPlayed < PlayerRecord.veryFreshLimit {
			// Played in last X days? Very fresh.
			return 1
		} else if daysSinceLastPlayed >= PlayerRecord.staleLimit {
			// Haven't played in Y days? Stale.
			return 0
		} else {
			// Otherwise, freshness is 0-1, based on number of days
			let maxFreshnessRange = PlayerRecord.staleLimit - PlayerRecord.veryFreshLimit
			let freshness = (maxFreshnessRange - (daysSinceLastPlayed - PlayerRecord.veryFreshLimit)) /
				maxFreshnessRange
			return max(0, min(1, freshness))
		}
	}
}
