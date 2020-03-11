//
//  RecordFragment+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-11.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import UIKit

public typealias RecordFragment = MyLeaderboardAPI.RecordFragment

extension RecordFragment {
	var formatted: String {
		return "\(wins) - \(losses)\(ties > 0 ? " - \(ties)" : "")"
	}

	var backgroundColor: UIColor? {
		if isBest ?? false {
			return .bestRecord
		} else if isWorst ?? false {
			return .worstRecord
		} else {
			return nil
		}
	}
}
