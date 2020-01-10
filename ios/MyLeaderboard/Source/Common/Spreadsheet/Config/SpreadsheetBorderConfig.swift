//
//  SpreadsheetBorderConfig.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

extension Spreadsheet {
	struct BorderConfig: Equatable {
		let color: UIColor
		let thickness: CGFloat

		init(color: UIColor = .black, thickness: CGFloat = 1) {
			self.color = color
			self.thickness = thickness
		}
	}
}
