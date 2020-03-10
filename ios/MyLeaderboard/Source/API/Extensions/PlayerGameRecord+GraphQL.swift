//
//  PlayerGameRecord+GraphQL.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-09.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

extension PlayerGameRecord.Game {
	init(from: MyLeaderboardAPI.PlayerDetailsResponse.Player.Records.Game) {
		self.id = from.id
		self.image = from.image
		self.name = from.name
	}
}

extension PlayerGameRecord {
	init(from: MyLeaderboardAPI.PlayerDetailsResponse.Player.Records) {
		self.game = PlayerGameRecord.Game(from: from.game)
		self.overallRecord = Record(from: from.overallRecord.asRecordFragmentFragment)
		self.stats = ScoreStats(from: from.scoreStats)
		self.records = from.records.map { PlayerVSRecord(from: $0) }
	}
}
