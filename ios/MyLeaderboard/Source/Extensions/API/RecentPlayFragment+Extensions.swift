//
//  RecentPlayFragment+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-11.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

public typealias RecentPlay = MyLeaderboardApi.RecentPlayFragment

extension RecentPlay {
	func isWinner(player: RecentPlay.Players) -> Bool {
		return winners.contains { $0.id == player.id }
	}
}

extension RecentPlay: GamePlay, Comparable { }
