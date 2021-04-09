//
//  Board.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-04-08.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import Foundation
import MyLeaderboardApi

enum Board {
	private static let lastUsedBoardKey = "Settings.LastUsedBoard"

	static var lastUsedBoard: BoardDetailsFragment? {
		get {
			if let data = UserDefaults.group.value(forKey: Board.lastUsedBoardKey) as? Data,
				 let board = try? JSONDecoder().decode(BoardDetailsFragment.self, from: data) {
				return board
			}

			return nil
		}
		set {
			if let data = try? JSONEncoder().encode(newValue) {
				UserDefaults.group.set(data, forKey: Board.lastUsedBoardKey)
				Player.preferred = nil
				Player.preferredOpponents = []
			} else if newValue == nil {
				UserDefaults.group.removeObject(forKey: Board.lastUsedBoardKey)
				Player.preferred = nil
				Player.preferredOpponents = []
			}
		}
	}
}
