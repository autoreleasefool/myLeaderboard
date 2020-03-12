//
//  PlayerDetails+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-11.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

public typealias PlayerDetails = MyLeaderboardAPI.PlayerDetailsFragment
public typealias PlayerDetailsRecord = MyLeaderboardAPI.PlayerDetailsRecordFragment
public typealias PlayerRecordOpponent = MyLeaderboardAPI.PlayerGameRecordFragment.Records.Opponent

extension PlayerRecordOpponent: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension PlayerRecordOpponent: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		guard let lhsID = Int(lhs.id.rawValue), let rhsID = Int(rhs.id.rawValue) else {
			return lhs.id < rhs.id
		}
		return lhsID < rhsID
	}
}
