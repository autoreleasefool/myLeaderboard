//
//  Player.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct Player: Identifiable, Equatable, Codable {
	let id: ID
	let avatar: String?
	let displayName: String
	let username: String
}

extension Player: Comparable {
	public static func < (lhs: Player, rhs: Player) -> Bool {
		if lhs.displayName != rhs.displayName {
			return lhs.displayName < rhs.displayName
		}
		return lhs.id < rhs.id
	}
}
