//
//  Game.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit

struct Game: Equatable, Codable {
	let id: Int
	let name: String
	let hasScores: Bool
	let image: String?
}
