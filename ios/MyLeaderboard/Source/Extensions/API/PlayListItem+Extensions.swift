//
//  PlayListItem+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-14.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

public typealias PlayListItem = MyLeaderboardApi.PlayListItem

extension PlayListItem: GamePlay, Comparable { }
