//
//  BoardDetails+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-04-08.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import Foundation
import MyLeaderboardApi

typealias BoardDetailsFragment = MyLeaderboardApi.BoardDetailsFragment

extension BoardDetailsFragment {
	var graphID: GraphID {
		return id
	}
}
