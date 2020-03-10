//
//  PlayerVSRecord.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-09.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

struct PlayerVSRecord: Equatable {
	struct Player: Equatable, Hashable {
		let id: GraphID
		let avatar: String?
	}

	let opponent: Player
	let record: Record
}

extension PlayerVSRecord.Player: Comparable {
	static func < (lhs: PlayerVSRecord.Player, rhs: PlayerVSRecord.Player) -> Bool {
		return lhs.id < rhs.id
	}
}
