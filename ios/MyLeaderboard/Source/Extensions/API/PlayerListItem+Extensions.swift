//
//  PlayerListItem+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-11.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit

typealias PlayerListItem = MyLeaderboardApi.PlayerListItem

extension PlayerListItem: Identifiable {
	var graphID: GraphID {
		return id
	}

	static var missingPlayerAvatar: UIImage {
		return UIImage(named: "MissingPlayer")!
	}

	var qualifiedAvatar: Avatar? {
		if let avatar = avatar {
			return .url(avatar)
		}

		return nil
	}
}

extension Optional where Wrapped == PlayerListItem {
	var qualifiedAvatar: Avatar? {
		switch self {
		case .some(let player):
			return player.qualifiedAvatar
		case .none:
			return .image(PlayerListItem.missingPlayerAvatar.withTintColor(.textSecondary))
		}
	}
}
