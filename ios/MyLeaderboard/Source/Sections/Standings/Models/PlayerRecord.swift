//
//  PlayerRecord.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct PlayerRecord: Codable {
	static let staleLimit: Double = 21
	static let veryFreshLimit: Double = 7
	static let dateFormatter = ISO8601DateFormatter()

	let scoreStats: Score?
	let lastPlayed: String
	let overallRecord: Record
	let records: [ID: Record]

	var isBanished: Bool {
		return freshness == 0
	}

	var freshness: Double {
		let today = Date()

		var lastPlayedWithoutMilliseconds = self.lastPlayed
		if let millisecondsIndex = lastPlayedWithoutMilliseconds.firstIndex(of: ".") {
			lastPlayedWithoutMilliseconds = String(lastPlayedWithoutMilliseconds.prefix(upTo: millisecondsIndex)) + "Z"
		}

		guard let lastPlayed = PlayerRecord.dateFormatter.date(from: lastPlayedWithoutMilliseconds) else {
			return 0
		}

		let seconds = today.timeIntervalSince(lastPlayed)
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
