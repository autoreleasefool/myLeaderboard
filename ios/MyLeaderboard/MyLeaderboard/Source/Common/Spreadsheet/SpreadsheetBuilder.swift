//
//  SpreadsheetBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class SpreadsheetBuilder {
	private weak var tableData: FunctionalTableData?

	private var configs: [String: Spreadsheet.Config] = [:]
	private var offsets: [String: CGPoint] = [:]

	init(tableData: FunctionalTableData) {
		self.tableData = tableData
	}

	func spreadsheet(forKey key: String, config: Spreadsheet.Config) -> TableSection {
		if configs[key] != config {
			configs[key] = config
			offsets[key] = .zero
		}

		let rows: [CellConfigType] = config.cells.enumerated().map { index, row in
			let border = rowCellBorderConfig(for: index, totalRows: config.cells.count, from: config.border)

			return Spreadsheet.RowCell(
				key: "\(key)-row-\(index)",
				actions: CellActions(
					visibilityAction: { [weak self] cell, visibility in
						self?.didUpdateVisibility(key: key, cell: cell, isVisible: visibility)
					}
				),
				state: Spreadsheet.RowCellState(
					spreadsheetKey: key,
					config: config.rows[index] ?? Spreadsheet.CommonRowConfig(),
					columns: config.columns,
					cells: row,
					border: border,
					didScroll: { [weak self] offset in
						self?.didScroll(key: key, offset: offset)
					}
				),
				cellUpdater: Spreadsheet.RowCellState.updateView
			)
		}

		return TableSection(key: key, rows: rows)
	}

	private func rowCellBorderConfig(for index: Int, totalRows: Int, from config: Spreadsheet.BorderConfig?) -> Spreadsheet.RowCellBorderConfig {
		guard let config = config else {
			return Spreadsheet.RowCellBorderConfig(topBorder: nil, bottomBorder: nil, leftBorder: nil, rightBorder: nil)
		}

		if index == 0 {
			return Spreadsheet.RowCellBorderConfig(topBorder: config, bottomBorder: nil, leftBorder: config, rightBorder: config)
		} else if index == totalRows - 1 {
			return Spreadsheet.RowCellBorderConfig(topBorder: nil, bottomBorder: config, leftBorder: config, rightBorder: config)
		} else {
			return Spreadsheet.RowCellBorderConfig(topBorder: nil, bottomBorder: nil, leftBorder: config, rightBorder: config)
		}
	}

	private func didUpdateVisibility(key: String, cell: UIView, isVisible: Bool) {
		guard isVisible else { return }

		guard tableData != nil else {
			clearKey(key: key)
			return
		}

		guard let rowCellView = cell.subviews.last?.subviews.first as? Spreadsheet.RowCellView,
			rowCellView.spreadsheetKey == key else {
			return
		}

		rowCellView.collectionView.contentOffset = offsets[key] ?? .zero
	}

	private func didScroll(key: String, offset: CGPoint) {
		guard let tableView = tableData?.tableView else {
			clearKey(key: key)
			return
		}

		offsets[key] = offset

		tableView.visibleCells.forEach {
			guard let rowCellView = $0.subviews.last?.subviews.first as? Spreadsheet.RowCellView,
				rowCellView.spreadsheetKey == key else {
				return
			}

			rowCellView.collectionView.contentOffset = offset
		}
	}

	private func clearKey(key: String) {
		configs[key] = nil
		offsets[key] = nil
	}
}
