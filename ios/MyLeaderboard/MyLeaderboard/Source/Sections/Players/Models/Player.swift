//
//  Player.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct Player: Equatable, Codable {
	let id: Int
	let avatar: String?
	let displayName: String
	let username: String
}
