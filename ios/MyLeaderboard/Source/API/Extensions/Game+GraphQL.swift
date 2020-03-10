//
//  Game+GraphQL.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-10.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

extension Game {
	init?(from: MyLeaderboardAPI.GameListItem?) {
		guard let from = from else { return nil }
		self.id = Int(from.id.rawValue)!
		self.image = from.image
		self.name = from.name
		self.hasScores = from.hasScores
	}
}
