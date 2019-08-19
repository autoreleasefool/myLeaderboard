//
//  SpreadsheetCell.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

extension Spreadsheet {
	typealias Cell = HostCell<CellView, CellState, LayoutMarginsTableItemLayout>

	class CellView: UIView {

	}

	struct CellState: ViewState {
		static func updateView(_ view: CellView, state: CellState?) {
			guard let state = state else {
				return
			}
		}
	}
}
