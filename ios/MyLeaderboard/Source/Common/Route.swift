//
//  Route.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-09-16.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

protocol RouteHandler {
	func openRoute(_ route: Route)
}

enum Route {
	case gameDetails(ID)
	case playerDetails(ID)
	case standings
	case preferredPlayer
	case preferredOpponents

	init?(from url: URL) {
		switch url.host {
		case "game":
			guard let id = Int(url.path.dropFirst()) else { return nil }
			self = .gameDetails(id)
		case "player":
			guard let id = Int(url.path.dropFirst()) else { return nil }
			self = .playerDetails(id)
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
			components.path = "/\(gameID)"
		case .playerDetails(let playerID):
			components.host = "player"
			components.path = "/\(playerID)"
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
