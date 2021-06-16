//
//  MyLeaderboardApi+Networking.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-03.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

extension MyLeaderboardApi {
	static let baseURL: URL = {
			#if DEBUG
			let debugURL = URL(string: "https://myleaderboardapi.josephroque.dev")!
			return debugURL
			#else
			let releaseURL = URL(string: "https://myleaderboardapi.josephroque.dev")!
			return releaseURL
			#endif
		}()
}
