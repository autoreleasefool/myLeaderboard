//
//  Record.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct Record: Codable {
	let wins: Int
	let losses: Int
	let ties: Int
	let isBest: Bool?
	let isWorst: Bool?
}
