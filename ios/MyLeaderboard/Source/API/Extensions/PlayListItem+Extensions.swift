//
//  PlayListItem+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-14.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation

public typealias PlayListItem = MyLeaderboardAPI.PlayListItem

extension PlayListItem {
	var playedOnDay: Date? {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: playedOn)
		return Calendar.current.date(from: components)
	}
}
