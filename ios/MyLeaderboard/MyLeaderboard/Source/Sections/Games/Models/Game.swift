//
//  Game.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit

struct Game: Identifiable, Equatable, Codable, Hashable {
	let id: ID
	let name: String
	let hasScores: Bool
	let image: String?
}

extension Game: Comparable {
	public static func < (lhs: Game, rhs: Game) -> Bool {
		return lhs.name < rhs.name
	}
}
