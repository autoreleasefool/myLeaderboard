//
//  GameListItem+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-11.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import myLeaderboardApi

public typealias GameListItem = MyLeaderboardApi.GameListItem

extension GameListItem: Comparable {
	public static func < (lhs: GameListItem, rhs: GameListItem) -> Bool {
		guard let lhsID = Int(lhs.id.rawValue), let rhsID = Int(rhs.id.rawValue) else {
			return lhs.id < rhs.id
		}

		return lhsID < rhsID
	}
}

extension GameListItem: Identifiable {
	var graphID: GraphID {
		return id
	}
}
