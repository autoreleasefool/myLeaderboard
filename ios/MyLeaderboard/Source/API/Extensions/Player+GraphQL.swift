//
//  Player+PlayerListItem.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-04.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

extension Player {
	init?(from: MyLeaderboardAPI.PlayerListItem?) {
		guard let from = from else { return nil }
		self.id = Int(from.id.rawValue)!
		self.avatar = from.avatar
		self.displayName = from.displayName
		self.username = from.username
	}
}

extension Player {
	init(from: MyLeaderboardAPI.PlayerDetailsResponse.Player) {
		self.id = Int(from.id.rawValue)!
		self.avatar = from.avatar
		self.displayName = from.displayName
		self.username = from.username
	}
}
