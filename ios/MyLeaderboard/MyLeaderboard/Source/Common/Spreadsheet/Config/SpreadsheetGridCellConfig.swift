//
//  SpreadsheetGridCellConfig.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol GridCellConfig {
	var key: String { get }

	var topBorder: Spreadsheet.BorderConfig? { get }
	var bottomBorder: Spreadsheet.BorderConfig? { get }
	var leftBorder: Spreadsheet.BorderConfig? { get }
	var rightBorder: Spreadsheet.BorderConfig? { get }

	var view: CellConfigType { get }

	func isEqual(_ other: GridCellConfig) -> Bool
}

extension Spreadsheet {
	struct TextGridCellConfig: GridCellConfig {
		private typealias Cell = HostCell<UILabel, LabelState, LayoutMarginsTableItemLayout>

		let key: String
		let state: LabelState

		let topBorder: Spreadsheet.BorderConfig?
		let bottomBorder: Spreadsheet.BorderConfig?
		let leftBorder: Spreadsheet.BorderConfig?
		let rightBorder: Spreadsheet.BorderConfig?

		var view: CellConfigType {
			return Cell(
				key: key,
				state: state,
				cellUpdater: LabelState.updateView
			)
		}

		func isEqual(_ other: GridCellConfig) -> Bool {
			guard let other = other as? TextGridCellConfig else { return false }
			return key == other.key &&
				state == other.state &&
				topBorder == other.topBorder &&
				bottomBorder == other.bottomBorder &&
				leftBorder == other.leftBorder &&
				rightBorder == other.rightBorder
		}
	}

	struct ImageGridCellConfig: GridCellConfig {
		private typealias Cell = HostCell<UIImageView, ImageState, LayoutMarginsTableItemLayout>

		let key: String
		let state: ImageState

		let topBorder: Spreadsheet.BorderConfig?
		let bottomBorder: Spreadsheet.BorderConfig?
		let leftBorder: Spreadsheet.BorderConfig?
		let rightBorder: Spreadsheet.BorderConfig?

		var view: CellConfigType {
			return Cell(
				key: key,
				state: state,
				cellUpdater: ImageState.updateView
			)
		}

		func isEqual(_ other: GridCellConfig) -> Bool {
			guard let other = other as? ImageGridCellConfig else { return false }
			return key == other.key &&
				state == other.state &&
				topBorder == other.topBorder &&
				bottomBorder == other.bottomBorder &&
				leftBorder == other.leftBorder &&
				rightBorder == other.rightBorder
		}
	}
}
