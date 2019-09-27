//
//  RootTabBarController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

enum TabType {
	case standings, games, players

	var title: String {
		switch self {
		case .standings: return "Standings"
		case .games: return "Games"
		case .players: return "Players"
		}
	}

	private var imageName: String {
		return "Tabs/\(self.title)"
	}

	var image: UIImage {
		return UIImage(named: self.imageName)!
	}

	var selectedImage: UIImage {
		return UIImage(named: "\(self.imageName)-selected")!
	}
}

struct TabItem {
	let type: TabType
	let controller: UIViewController
}

class RootTabBarController: UITabBarController {
	private lazy var tabItems: [TabItem] = {
		return [
			TabItem(
				type: .standings,
				controller: UINavigationController(rootViewController: StandingsListViewController(api: api))
			),
			TabItem(
				type: .games,
				controller: UINavigationController(rootViewController: GameListViewController(api: api))
			),
			TabItem(
				type: .players,
				controller: UINavigationController(rootViewController: PlayerListViewController(api: api))
			),
		]
	}()

	private var api: LeaderboardAPI!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.api = LeaderboardAPI()
		self.viewControllers = createTabBarItems()
	}

	private func createTabBarItems() -> [UIViewController] {
		return tabItems.map {
			let viewController = $0.controller
			viewController.tabBarItem = UITabBarItem(
				title: $0.type.title,
				image: $0.type.image,
				selectedImage: $0.type.selectedImage
			)

			return viewController
		}
	}
}

extension RootTabBarController: RouteHandler {
	func openRoute(_ route: Route) {
		let controller: UIViewController?

		switch route {
		case .gameDetails:
			let gameTabItem = tabItems.first { $0.type == .games }
			self.selectedViewController = gameTabItem?.controller
			controller = gameTabItem?.controller.children.first
		case .playerDetails:
			let playerTabItem = tabItems.first { $0.type == .players }
			self.selectedViewController = playerTabItem?.controller
			controller = playerTabItem?.controller.children.first
		case .standings, .preferredPlayer:
			let standingsTabItem = tabItems.first { $0.type == .standings }
			self.selectedViewController = standingsTabItem?.controller
			controller = standingsTabItem?.controller.children.first
		}

		DispatchQueue.main.async {
			if let routeHandler = controller as? RouteHandler {
				routeHandler.openRoute(route)
			}
		}
	}
}
