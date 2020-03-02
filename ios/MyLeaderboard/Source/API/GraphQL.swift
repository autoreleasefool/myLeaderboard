//
//  GraphQL.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-02.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation

public enum GraphQL {
	public static let posixLocale = Locale(identifier: "en_US_POSIX")

	public static let iso8601DateParser: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = posixLocale
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		return formatter
	}()
}
