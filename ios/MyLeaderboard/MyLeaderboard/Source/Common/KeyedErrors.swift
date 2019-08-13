//
//  KeyedErrors.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct KeyedErrors {
	private var errors: [String: [String: String]] = [:]

	subscript(key: String) -> [String: String]? {
		return errors[key]
	}

	subscript(key: String, subkey: String) -> String? {
		get {
			return errors[key]?[subkey]
		}
		set {
			if errors[key] == nil {
				errors[key] = [:]
			}

			errors[key]?[subkey] = newValue

			if errors[key]?.isEmpty == true {
				errors[key] = nil
			}
		}
	}

	var isEmpty: Bool {
		return errors.isEmpty
	}
}
