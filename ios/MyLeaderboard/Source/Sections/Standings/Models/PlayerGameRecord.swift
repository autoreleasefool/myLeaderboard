//
//  PlayerGameRecord.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-09.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

struct PlayerGameRecord: Equatable {
	struct Game: Equatable {
		let id: GraphID
		let image: String?
		let name: String
	}

	let game: Game
	let overallRecord: Record
	let stats: ScoreStats?
	let records: [PlayerVSRecord]
}

extension PlayerGameRecord: Comparable {
	static func < (lhs: PlayerGameRecord, rhs: PlayerGameRecord) -> Bool {
		return lhs.game.id < rhs.game.id
	}
}
