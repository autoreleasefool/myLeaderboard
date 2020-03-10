//
//  ScoreStats+GraphQL.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-09.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

extension ScoreStats {
	init?(from: MyLeaderboardAPI.PlayerDetailsResponse.Player.Records.ScoreStats?) {
		guard let from = from else { return nil }
		self.best = Int(from.best)
		self.worst = Int(from.worst)
		self.average = from.average
	}
}
