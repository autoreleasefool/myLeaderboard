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
	public var interfaceSize: UIUserInterfaceSizeClass = .unspecified

	init(tableData: FunctionalTableData) {
		self.tableData = tableData
	}

	func spreadsheet(forKey key: String, config: Spreadsheet.Config) -> TableSection {
		if configs[key] != config {
			configs[key] = config
			offsets[key] = .zero
		}

		let padRows: Bool
		switch interfaceSize {
		case .regular: padRows = true
		case .compact, .unspecified: padRows = false
		@unknown default: padRows = false
		}

		let rows: [CellConfigType] = config.cells.enumerated().map { index, row in
			let border = rowCellBorderConfig(for: index, totalRows: config.cells.count, from: config.border)
			let rowKey = "\(key)-row-\(index)"
			let rowActions = CellActions(
				visibilityAction: { [weak self] cell, visibility in
					self?.didUpdateVisibility(key: key, cell: cell, isVisible: visibility)
				}
			)
			let rowState = Spreadsheet.RowCellState(
				spreadsheetKey: key,
				config: config.rows[index] ?? Spreadsheet.CommonRowConfig(),
				columns: config.columns,
				cells: row,
				border: border,
				didScroll: { [weak self] offset in
					self?.didScroll(key: key, offset: offset)
				}
			)

			if padRows {
				return Spreadsheet.RowCellPadded(
					key: rowKey,
					actions: rowActions,
					state: rowState,
					cellUpdater: Spreadsheet.RowCellState.updateView
				)
			} else {
				return Spreadsheet.RowCell(
					key: rowKey,
					actions: rowActions,
					state: rowState,
					cellUpdater: Spreadsheet.RowCellState.updateView
				)
			}
		}

		return TableSection(key: key, rows: rows)
	}

	private func rowCellBorderConfig(
		for index: Int,
		totalRows: Int,
		from config: Spreadsheet.BorderConfig?
	) -> Spreadsheet.RowCellBorderConfig {
		guard let config = config else {
			return Spreadsheet.RowCellBorderConfig(equalTo: nil)
		}

		let topBorder: Spreadsheet.BorderConfig?
		let bottomBorder: Spreadsheet.BorderConfig?
		let horizontalBorder = config

		if index == 0 {
			topBorder = config
			bottomBorder = nil
		} else if index == totalRows - 1 {
			topBorder = nil
			bottomBorder = config
		} else {
			topBorder = nil
			bottomBorder = nil
		}

		return Spreadsheet.RowCellBorderConfig(
			topBorder: topBorder,
			bottomBorder: bottomBorder,
			leftBorder: horizontalBorder,
			rightBorder: horizontalBorder
		)
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
