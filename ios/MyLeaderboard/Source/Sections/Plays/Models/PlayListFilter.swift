//
//  PlayListFilter.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-15.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

struct PlayListFilter {
	let gameID: GraphID?
	let playerIDs: [GraphID]

	init(gameID: GraphID? = nil, playerIDs: [GraphID] = []) {
		self.gameID = gameID
		self.playerIDs = playerIDs
	}
}
