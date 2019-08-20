//
//  SpreadsheetRowConfig.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

extension Spreadsheet {
	struct RowConfig: Equatable {
		let isSticky: Bool
		let rowHeight: CGFloat
		let topBorder: BorderConfig?
		let bottomBorder: BorderConfig?

		init(
			isSticky: Bool = false,
			rowHeight: CGFloat = 48,
			topBorder: BorderConfig? = BorderConfig(),
			bottomBorder: BorderConfig? = BorderConfig()) {
			self.isSticky = isSticky
			self.rowHeight = rowHeight
			self.topBorder = topBorder
			self.bottomBorder = bottomBorder
		}

		static let Header = RowConfig(isSticky: true, topBorder: BorderConfig(thickness: 3), bottomBorder: BorderConfig(thickness: 3))
		static let `default` = RowConfig()
	}
}
