//
//  StandingsFragment+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-15.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation
import MyLeaderboardApi

public typealias StandingsFragment = MyLeaderboardApi.StandingsFragment
public typealias StandingsGame = MyLeaderboardApi.StandingsGameFragment
public typealias StandingsPlayerRecordNext = MyLeaderboardApi.StandingsPlayerRecordFragment
public typealias StandingsPlayerGameRecord = MyLeaderboardApi.StandingsPlayerGameRecordFragment

extension StandingsGame: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension StandingsPlayerGameRecord {
	static let staleLimit: Double = 21
	static let veryFreshLimit: Double = 7
	static let dateFormatter = ISO8601DateFormatter()

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

		if daysSinceLastPlayed < StandingsPlayerGameRecord.veryFreshLimit {
			// Played in last X days? Very fresh.
			return 1
		} else if daysSinceLastPlayed >= StandingsPlayerGameRecord.staleLimit {
			// Haven't played in Y days? Stale.
			return 0
		} else {
			// Otherwise, freshness is 0-1, based on number of days
			let maxFreshnessRange = StandingsPlayerGameRecord.staleLimit - StandingsPlayerGameRecord.veryFreshLimit
			let freshness = (maxFreshnessRange - (daysSinceLastPlayed - StandingsPlayerGameRecord.veryFreshLimit)) /
				maxFreshnessRange
			return max(0, min(1, freshness))
		}
	}
}
