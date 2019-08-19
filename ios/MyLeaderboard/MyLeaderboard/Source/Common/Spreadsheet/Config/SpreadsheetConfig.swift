//
//  SpreadsheetConfig.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

extension Spreadsheet {
	class Config: Equatable {
		let rows: [Int: RowConfig]
		let columns: [Int: ColumnConfig]
		let cells: [[GridCellConfig]]
		weak var tableData: FunctionalTableData?

		init(rows: [Int: RowConfig], columns: [Int: ColumnConfig], cells: [[GridCellConfig]], in tableData: FunctionalTableData) {
			self.rows = rows
			self.columns = columns
			self.cells = cells
			self.tableData = tableData
		}

		static func == (lhs: Config, rhs: Config) -> Bool {
			guard lhs.rows == rhs.rows &&
				lhs.columns == rhs.columns &&
				lhs.tableData === rhs.tableData else {
				return false
			}

			guard lhs.cells.count == rhs.cells.count else { return false }
			for (rowIndex, row) in lhs.cells.enumerated() {
				if row.count != rhs.cells[rowIndex].count { return false }
				for (index, cell) in row.enumerated() {
					if cell.isEqual(rhs.cells[rowIndex][index]) == false {
						return false
					}
				}
			}

			return true
		}
	}
}
