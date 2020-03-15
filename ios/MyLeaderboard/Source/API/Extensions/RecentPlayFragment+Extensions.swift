//
//  RecentPlayFragment+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-11.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation

public typealias RecentPlay = MyLeaderboardAPI.RecentPlayFragment

extension RecentPlay {
	func isWinner(player: RecentPlay.Players) -> Bool {
		return winners.contains { $0.id == player.id }
	}

	var playedOnDay: Date? {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: playedOn)
		return Calendar.current.date(from: components)
	}
}

extension RecentPlay: Comparable {
	public static func < (lhs: RecentPlay, rhs: RecentPlay) -> Bool {
		return lhs.playedOn < rhs.playedOn
	}
}
