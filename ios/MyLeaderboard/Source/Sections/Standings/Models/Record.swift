//
//  Record.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit

struct Record: Equatable, Codable {
	let wins: Int
	let losses: Int
	let ties: Int
	@available(*, deprecated, message: "Use isBestNext instead")
	let isBest: Bool?
	@available(*, deprecated, message: "Use isWorstNext instead")
	let isWorst: Bool?

	static var empty: Record {
		return Record(wins: 0, losses: 0, ties: 0, isBest: false, isWorst: false)
	}

	var isBestNext: Bool {
		return self.isBest ?? false
	}

	var isWorstNext: Bool {
		return self.isWorst ?? false
	}

	var formatted: String {
		return "\(wins) - \(losses)\(ties > 0 ? " - \(ties)" : "")"
	}

	var backgroundColor: UIColor? {
		if isBestNext {
			return .bestRecord
		} else if isWorstNext {
			return .worstRecord
		} else {
			return nil
		}
	}
}
