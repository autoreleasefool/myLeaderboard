//
//  Maple+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-06-19.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import Foundation
import Maple

extension GraphError where E == MyLeaderboardAPIError {
	var graphQLError: MyLeaderboardAPIError? {
		guard case let .networkError(error) = self else {
			return nil
		}

		return error
	}
}
