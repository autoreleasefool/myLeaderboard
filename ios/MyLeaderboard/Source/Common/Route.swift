//
//  Route.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-09-16.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

protocol RouteHandler {
	func openRoute(_ route: Route)
}

enum Route {
	case gameDetails(GraphID)
	case playerDetails(GraphID)
	case standings
	case preferredPlayer
	case preferredOpponents

	init?(from url: URL) {
		switch url.host {
		case "game":
			self = .gameDetails(GraphID(rawValue: String(url.path.dropFirst())))
		case "player":
			self = .playerDetails(GraphID(rawValue: String(url.path.dropFirst())))
		case "standings":
			self = .standings
		case "preferredPlayer":
			self = .preferredPlayer
		case "preferredOpponents":
			self = .preferredOpponents
		default:
			return nil
		}
	}

	var url: URL {
		var components = URLComponents()
		components.scheme = "myleaderboard"

		switch self {
		case .gameDetails(let gameID):
			components.host = "game"
			components.path = "/\(gameID.rawValue)"
		case .playerDetails(let playerID):
			components.host = "player"
			components.path = "/\(playerID.rawValue)"
		case .standings:
			components.host = "standings"
		case .preferredPlayer:
			components.host = "preferredPlayer"
		case .preferredOpponents:
			components.host = "preferredOpponents"
		}

		return components.url!
	}
}
