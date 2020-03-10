//
//  RecentPlay+GraphQL.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-09.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

extension RecentPlay.Game {
	init(from: MyLeaderboardAPI.RecentPlayFragment.Game) {
		self.image = from.image
	}
}

extension RecentPlay.Player {
	init(from: MyLeaderboardAPI.RecentPlayFragment.Players) {
		self.id = from.id
		self.avatar = from.avatar
	}
}

extension RecentPlay.Winner {
	init(from: MyLeaderboardAPI.RecentPlayFragment.Winners) {
		self.id = from.id
	}
}

extension RecentPlay {
	init(from: MyLeaderboardAPI.RecentPlayFragment) {
		self.id = from.id
		self.playedOn = from.playedOn
		self.scores = from.scores?.map { Int($0) } ?? []
		self.game = RecentPlay.Game(from: from.game)
		self.players = from.players.map { RecentPlay.Player(from: $0) }
		self.winners = from.winners.map { RecentPlay.Winner(from: $0) }
	}
}
