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
		UINavigationBar.appearance().tintColor = .text
		UINavigationBar.appearance().barTintColor = .primaryLight

		UITextField.appearance().textColor = .text
		UILabel.appearance().textColor = .text
	}

	private static var interfaceStyleKey = "Settings.Theme.InterfaceStyle"

	static var interfaceStyle: UIUserInterfaceStyle {
		set {
			UserDefaults.group.set(newValue.stringValue, forKey: Theme.interfaceStyleKey)
		}
		get {
			return UIUserInterfaceStyle.init(from: UserDefaults.group.string(forKey: Theme.interfaceStyleKey))
		}
	}
}

extension UIUserInterfaceStyle {
	var stringValue: String {
		switch self {
		case .dark: return "Dark"
		case .light: return "Light"
		case .unspecified: return "System"
		@unknown default: return "System"
		}
	}

	init(from: String?) {
		switch from {
		case "Dark": self = .dark
		case "Light": self = .light
		case "System": self = .unspecified
		default: self = .unspecified
		}
	}
}
