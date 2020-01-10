//
//  Score.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct Score: Codable {
	let best: Int
	let worst: Int
	let average: Double
	let gamesPlayed: Int
}
