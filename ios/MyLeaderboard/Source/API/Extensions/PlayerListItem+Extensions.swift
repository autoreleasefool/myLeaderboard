//
//  PlayerListItem+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-11.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

typealias PlayerListItem = MyLeaderboardAPI.PlayerListItem

extension PlayerListItem: GraphQLIdentifiable {
	var graphID: GraphID {
		return id
	}

	var qualifiedAvatar: Avatar? {
		if let avatar = avatar {
			return .url(avatar)
		}

		return nil
	}
}

extension Player {
	init?(from: PlayerListItem?) {
		guard let from = from else { return nil }
		self.id = Int(from.id.rawValue)!
		self.displayName = from.displayName
		self.username = from.username
		self.avatar = from.avatar
	}
}

extension PlayerListItem {
	init(from: Player) {
		self.init(
			id: from.graphID,
			displayName: from.displayName,
			username: from.username,
			avatar: from.avatar
		)
	}
}
