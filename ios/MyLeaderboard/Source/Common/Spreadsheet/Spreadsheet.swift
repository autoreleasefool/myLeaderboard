//
//  Spreadsheet.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

enum Spreadsheet {
	static func section(key: String, builder: SpreadsheetBuilder, config: Config) -> TableSection? {
		return builder.spreadsheet(forKey: key, config: config)
	}
}
