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
		let isSticky: Bool
		let columnWidth: CGFloat
		let leftBorder: BorderConfig?
		let rightBorder: BorderConfig?

		init(
			isSticky: Bool = false,
			columnWidth: CGFloat = 48,
			leftBorder: BorderConfig? = BorderConfig(),
			rightBorder: BorderConfig? = BorderConfig()) {
			self.isSticky = isSticky
			self.columnWidth = columnWidth
			self.leftBorder = leftBorder
			self.rightBorder = rightBorder
		}

		static let Header = ColumnConfig(isSticky: true, leftBorder: BorderConfig(thickness: 3), rightBorder: BorderConfig(thickness: 3))
	}
}
