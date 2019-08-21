//
//  SpreadsheetColumnConfig.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

extension Spreadsheet {
	struct ColumnConfig: Equatable {
		let columnWidth: CGFloat
		let leftBorder: BorderConfig?
		let rightBorder: BorderConfig?

		init(
			columnWidth: CGFloat = 48,
			leftBorder: BorderConfig? = BorderConfig(),
			rightBorder: BorderConfig? = BorderConfig()) {
			self.columnWidth = columnWidth
			self.leftBorder = leftBorder
			self.rightBorder = rightBorder
		}
	}
}
