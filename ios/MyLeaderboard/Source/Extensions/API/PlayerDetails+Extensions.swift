//
//  PlayerDetails+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-11.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import myLeaderboardApi

public typealias PlayerDetails = MyLeaderboardApi.PlayerDetailsFragment
public typealias PlayerDetailsRecord = MyLeaderboardApi.PlayerDetailsRecordFragment
public typealias Opponent = MyLeaderboardApi.OpponentFragment

extension Opponent: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension Opponent: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		guard let lhsID = Int(lhs.id.rawValue), let rhsID = Int(rhs.id.rawValue) else {
			return lhs.id < rhs.id
		}
		return lhsID < rhsID
	}
}
