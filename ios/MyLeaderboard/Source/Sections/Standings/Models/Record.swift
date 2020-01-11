//
//  Record.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit

struct Record: Codable {
	let wins: Int
	let losses: Int
	let ties: Int
	let isBest: Bool?
	let isWorst: Bool?

	var formatted: String {
		return "\(wins) - \(losses)\(ties > 0 ? " - \(ties)" : "")"
	}

	var backgroundColor: UIColor? {
		if isBest == true {
			return .bestRecord
		} else if isWorst == true {
			return .worstRecord
		} else {
			return nil
		}
	}
}
