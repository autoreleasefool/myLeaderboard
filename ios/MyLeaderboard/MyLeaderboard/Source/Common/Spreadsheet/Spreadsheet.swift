//
//  Spreadsheet.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

struct Spreadsheet {
	static func section(key: String, config: Config) -> TableSection? {
		return SpreadsheetBuilder.shared.spreadsheet(forKey: key, config: config)
	}
}
