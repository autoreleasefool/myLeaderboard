//
//  PlayerVSRecord+GraphQL.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-09.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

extension PlayerVSRecord.Player {
	init(from: MyLeaderboardAPI.PlayerDetailsResponse.Player.Records.Records.Opponent) {
		self.id = from.id
		self.avatar = from.avatar
	}
}

extension PlayerVSRecord {
	init(from: MyLeaderboardAPI.PlayerDetailsResponse.Player.Records.Records) {
		self.opponent = PlayerVSRecord.Player(from: from.opponent)
		self.record = Record(from: from.record.asRecordFragmentFragment)
	}
}
