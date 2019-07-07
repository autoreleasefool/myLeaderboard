//
//  Game.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit

struct Game: Codable {
	let name: String
	let iconName: String

	var icon: UIImage {
		return UIImage(named: iconName)!
	}
}
