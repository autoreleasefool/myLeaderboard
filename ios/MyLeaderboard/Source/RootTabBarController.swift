//
//  RootTabBarController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import MyLeaderboardApi
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
}

struct TabItem {
	let type: TabType
	let controller: UIViewController
}

class RootTabBarController: UITabBarController {
	private let boardId: GraphID

	private lazy var tabItems: [TabItem] = {
		return [
			TabItem(
				type: .standings,
				controller: UINavigationController(rootViewController: StandingsListViewController(boardId: boardId))
			),
			TabItem(
				type: .games,
				controller: UINavigationController(rootViewController: GameListViewController(boardId: boardId))
			),
			TabItem(
				type: .players,
				controller: UINavigationController(rootViewController: PlayerListViewController(boardId: boardId))
			),
		]
	}()

	init(boardId: GraphID) {
		self.boardId = boardId
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.viewControllers = createTabBarItems()
		self.tabBar.tintColor = .tab
	}

	private func createTabBarItems() -> [UIViewController] {
		return tabItems.map {
			let viewController = $0.controller
			viewController.tabBarItem = UITabBarItem(
				title: $0.type.title,
				image: $0.type.image,
				selectedImage: $0.type.image
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
		case .standings, .preferredPlayer, .preferredOpponents:
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
