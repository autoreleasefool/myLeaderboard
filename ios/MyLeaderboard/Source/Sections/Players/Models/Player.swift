//
//  Player.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import MyLeaderboardApi

enum Player {
	private static let preferredPlayerKey = "Settings.PreferredPlayer"
	private static let preferredOpponentsKey = "Settings.PreferredOpponents"

	static var preferredOpponentsLimit: Int = 2

	static var preferred: PlayerListItem? {
		get {
			if let data = UserDefaults.group.value(forKey: Player.preferredPlayerKey) as? Data,
				let player = try? JSONDecoder().decode(LegacyPlayer.self, from: data) {
				return PlayerListItem(from: player)
			}

			return nil
		}
		set {

			if let player = LegacyPlayer(from: newValue),
				let data = try? JSONEncoder().encode(player) {
				UserDefaults.group.set(data, forKey: Player.preferredPlayerKey)
			} else if newValue == nil {
				UserDefaults.group.removeObject(forKey: Player.preferredPlayerKey)
			}
		}
	}

	static var preferredOpponents: [PlayerListItem] {
		get {
			if let data = UserDefaults.group.value(forKey: Player.preferredOpponentsKey) as? Data,
				let opponents = try? JSONDecoder().decode([LegacyPlayer].self, from: data) {
				return opponents.map { PlayerListItem(from: $0) }
			}

			return []
		}
		set {
			let opponents = newValue.compactMap { LegacyPlayer(from: $0) }
			if let data = try? JSONEncoder().encode(Array(opponents.prefix(preferredOpponentsLimit))) {
				UserDefaults.group.set(data, forKey: Player.preferredOpponentsKey)
			}
		}
	}
}

private struct LegacyPlayer: Identifiable, Equatable, Codable, Hashable {
	// swiftlint:disable:next identifier_name
	let id: Int
	let avatar: String?
	let displayName: String
	let username: String

	var graphID: GraphID {
		return GraphID(rawValue: String(id))
	}
}

extension PlayerListItem {
	fileprivate init(from: LegacyPlayer) {
		self.init(
			id: from.graphID,
			displayName: from.displayName,
			username: from.username,
			avatar: from.avatar
		)
	}
}

extension LegacyPlayer {
	fileprivate init?(from: PlayerListItem?) {
		guard let from = from else { return nil }
		self.id = Int(String(from.id.rawValue))!
		self.displayName = from.displayName
		self.username = from.username
		self.avatar = from.avatar
	}
}
