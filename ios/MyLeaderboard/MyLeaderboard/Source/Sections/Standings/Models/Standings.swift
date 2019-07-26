//
//  Standings.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct Standings: Codable {
	let scoreStats: Score?
	let records: [ID: Record]
}
