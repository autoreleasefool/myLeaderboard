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
	static let shared = SpreadsheetBuilder()

	private var configs: [String: Spreadsheet.Config] = [:]
	private var offsets: [String: CGPoint] = [:]

	func spreadsheet(forKey key: String, config: Spreadsheet.Config) -> TableSection {
		if configs[key] != config {
			configs[key] = config
			offsets[key] = .zero
		}

		let rows: [CellConfigType] = config.cells.enumerated().map { index, row in
			return Spreadsheet.RowCell(
				key: "\(key)-row-\(index)",
				actions: CellActions(
					visibilityAction: { [weak self] cell, visibility in
						self?.didUpdateVisibility(key: key, cell: cell, isVisible: visibility)
					}
				),
				state: Spreadsheet.RowCellState(
					spreadsheetKey: key,
					config: config.rows[index] ?? Spreadsheet.RowConfig(),
					columns: config.columns,
					cells: row,
					didScroll: { [weak self] offset in
						self?.didScroll(key: key, offset: offset)
					}
				),
				cellUpdater: Spreadsheet.RowCellState.updateView
			)
		}

		return TableSection(key: key, rows: rows)
	}

	private func didUpdateVisibility(key: String, cell: UIView, isVisible: Bool) {
		guard isVisible else { return }

		guard let config = configs[key], config.tableData != nil else {
			clearKey(key: key)
			return
		}

		guard let tableViewCell = cell as? Spreadsheet.RowCell.TableViewCellType,
			let rowCellView = tableViewCell.subviews.first as? Spreadsheet.RowCellView,
			rowCellView.spreadsheetKey == key else {
			return
		}

		rowCellView.collectionView.contentOffset = offsets[key] ?? .zero
	}

	private func didScroll(key: String, offset: CGPoint) {
		guard let config = configs[key], let tableData = config.tableData, let tableView = tableData.tableView else {
			clearKey(key: key)
			return
		}

		offsets[key] = offset

		tableView.visibleCells.forEach {
			guard let rowCellView = $0.subviews.first as? Spreadsheet.RowCellView,
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
