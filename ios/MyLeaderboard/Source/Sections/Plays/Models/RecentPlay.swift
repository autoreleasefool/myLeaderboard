//
//  RecentPlay.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-09.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation

struct RecentPlay: Equatable {
	struct Game: Equatable {
		let image: String?
	}

	struct Player: Equatable {
		let id: GraphID
		let avatar: String?
	}

	struct Winner: Equatable {
		let id: GraphID
	}

	let id: GraphID
	let game: Game
	let playedOn: Date
	let scores: [Int]
	let players: [Player]
	let winners: [Winner]

	func isWinner(player: Player) -> Bool {
		return winners.contains { $0.id == player.id }
	}

	var playedOnDay: Date? {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: playedOn)
		return Calendar.current.date(from: components)
	}
}

extension RecentPlay: Comparable {
	static func < (lhs: RecentPlay, rhs: RecentPlay) -> Bool {
		return lhs.playedOn < rhs.playedOn
	}
}
