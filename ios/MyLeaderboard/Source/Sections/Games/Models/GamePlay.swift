//
//  GamePlay.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct GamePlay: Identifiable, Codable {
	private static let dateFormatter = ISO8601DateFormatter()

	// swiftlint:disable:next identifier_name
	let id: ID
	let game: ID
	let players: [ID]
	let winners: [ID]
	let scores: [Int]?
	let playedOn: String

	var playedOnDate: Date? {
		var playedOnWithoutMilliseconds = self.playedOn
		if let millisecondsIndex = playedOnWithoutMilliseconds.firstIndex(of: ".") {
			playedOnWithoutMilliseconds = String(playedOnWithoutMilliseconds.prefix(upTo: millisecondsIndex)) + "Z"
		}
		return GamePlay.dateFormatter.date(from: playedOnWithoutMilliseconds)
	}

	var playedOnDay: Date? {
		guard let date = playedOnDate else { return nil }
		let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
		return Calendar.current.date(from: components)
	}
}

extension GamePlay: Comparable {
	static func < (lhs: GamePlay, rhs: GamePlay) -> Bool {
		switch (lhs.playedOnDate, rhs.playedOnDate) {
		case (.some(let lhsDate), .some(let rhsDate)):
			if lhsDate != rhsDate {
				return lhsDate < rhsDate
			}
		case (nil, _):
			return false
		case (_, nil):
			return true
		}

		return lhs.id < rhs.id
	}
}
