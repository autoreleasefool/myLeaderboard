//
//  SpreadsheetRowConfig.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

protocol RowConfig {
	var rowHeight: CGFloat { get }
	var topBorder: Spreadsheet.BorderConfig? { get }
	var bottomBorder: Spreadsheet.BorderConfig? { get }

	func isEqual(to other: RowConfig?) -> Bool
}

extension Spreadsheet {
	typealias RowConfig = MyLeaderboard.RowConfig

	struct HeaderRowConfig: RowConfig {
		let header: GridCellConfig?
		let rowHeight: CGFloat
		let topBorder: BorderConfig?
		let bottomBorder: BorderConfig?

		init(
			header: GridCellConfig? = nil,
			rowHeight: CGFloat = 48,
			topBorder: BorderConfig? = BorderConfig(),
			bottomBorder: BorderConfig? = BorderConfig()) {
			self.header = header
			self.rowHeight = rowHeight
			self.topBorder = topBorder
			self.bottomBorder = bottomBorder
		}

		func isEqual(to other: RowConfig?) -> Bool {
			guard let other = other as? HeaderRowConfig else { return false }
			return (header?.isEqual(to: other.header) ?? false) &&
				rowHeight == other.rowHeight &&
				topBorder == other.topBorder &&
				bottomBorder == other.bottomBorder
		}
	}

	struct CommonRowConfig: RowConfig {
		let rowHeight: CGFloat
		let topBorder: BorderConfig?
		let bottomBorder: BorderConfig?

		init(
			rowHeight: CGFloat = 48,
			topBorder: BorderConfig? = BorderConfig(),
			bottomBorder: BorderConfig? = BorderConfig()) {
			self.rowHeight = rowHeight
			self.topBorder = topBorder
			self.bottomBorder = bottomBorder
		}

		func isEqual(to other: RowConfig?) -> Bool {
			guard let other = other as? CommonRowConfig else { return false }
			return rowHeight == other.rowHeight &&
				topBorder == other.topBorder &&
				bottomBorder == other.bottomBorder
		}
	}
}
