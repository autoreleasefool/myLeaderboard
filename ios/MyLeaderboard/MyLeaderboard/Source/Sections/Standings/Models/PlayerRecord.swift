//
//  PlayerRecord.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct PlayerRecord: Codable {
	let scoreStats: Score?
	let lastPlayed: String
	let overallRecord: Record
	let record: [Int: Record]
}
