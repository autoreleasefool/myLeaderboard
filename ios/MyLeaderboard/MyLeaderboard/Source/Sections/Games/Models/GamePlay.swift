//
//  GamePlay.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

typealias ID = Int
protocol Identifiable {
    var id: ID { get }
}

struct GamePlay: Identifiable, Codable {
	let id: ID
	let game: ID
	let players: [ID]
	let winners: [ID]
	let scores: [Int]?
	let playedOn: String

	var playedOnDate: Date? {
		let dateFormatter = ISO8601DateFormatter()
		return dateFormatter.date(from: playedOn)
	}
}
