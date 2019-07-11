//
//  Theme.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

struct Theme {
	static func apply() {
		CellStyle.defaultBackgroundColor = .primary
		CellStyle.defaultSelectionColor = .selection

		UINavigationBar.appearance().barStyle = .black
		UINavigationBar.appearance().tintColor = .textSecondary
		UINavigationBar.appearance().barTintColor = .primaryLight

		UITextField.appearance().textColor = .text
		UILabel.appearance().textColor = .text
	}
}
