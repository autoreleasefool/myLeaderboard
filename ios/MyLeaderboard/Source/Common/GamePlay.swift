//
//  GamePlay.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-16.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation

public protocol GamePlay {
	var playedOn: Date { get }
	var formattedDate: String { get }
	var playedOnDay: Date? { get }
}

private let outdatedDate = Date(timeIntervalSince1970: 1562018399)

private let defaultDateFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateFormat = "MMMM d, YYYY"
	return formatter
}()

private let shortDateFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateFormat = "MMMM d"
	return formatter
}()

extension GamePlay {
	public var playedOnDay: Date? {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: playedOn)
		return Calendar.current.date(from: components)
	}

	public var formattedDate: String {
		let playedOn = playedOnDay ?? outdatedDate

		if outdatedDate >= playedOn {
			return "Older than \(defaultDateFormatter.string(from: outdatedDate))"
		}

		guard let currentYear = Calendar.current.dateComponents([.year], from: Date()).year,
			let playedOnYear = Calendar.current.dateComponents([.year], from: playedOn).year else {
			return defaultDateFormatter.string(from: playedOn)
		}

		if currentYear != playedOnYear {
			return defaultDateFormatter.string(from: playedOn)
		} else {
			return shortDateFormatter.string(from: playedOn)
		}
	}
}

extension GamePlay where Self: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		return lhs.playedOn < rhs.playedOn
	}
}
