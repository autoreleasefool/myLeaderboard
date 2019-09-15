//
//  UserDefaults+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-09-15.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

public extension UserDefaults {
	static let group: UserDefaults = {
		return UserDefaults(suiteName: "group.ca.josephroque.MyLeaderboard") ?? UserDefaults.standard
	}()
}
