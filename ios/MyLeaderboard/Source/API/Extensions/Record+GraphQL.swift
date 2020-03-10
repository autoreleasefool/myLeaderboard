//
//  Record+GraphQL.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-09.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

extension Record {
	init(from: MyLeaderboardAPI.RecordFragment) {
		self.wins = Int(from.wins)
		self.losses = Int(from.losses)
		self.ties = Int(from.ties)
		self.isBest = from.isBest
		self.isWorst = from.isWorst
	}
}
