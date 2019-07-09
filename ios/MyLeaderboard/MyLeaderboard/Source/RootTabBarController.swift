//
//  RootTabBarController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

struct TabItem {
	let title: String
	let controller: () -> UIViewController
	let image: UIImage
	let selectedImage: UIImage
}

class RootTabBarController: UITabBarController {
	private lazy var tabItems: [TabItem] = {
		return [
			TabItem(
				title: "Games",
				controller: { [weak self] in
					return GameListViewController(api: self?.api)
				},
				image: UIImage(named: "Tabs/Games")!,
				selectedImage: UIImage(named: "Tabs/Games-selected")!
			),
		]
	}

	private var api: LeaderboardAPI!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.api = LeaderboardAPI()
		self.viewControllers = createTabBarItems()
	}

	private func createTabBarItems() -> [UIViewController] {
		return tabItems.map {
			let viewController = $0.controller()
			viewController.tabBarItem = UITabBarItem(
				title: $0.title,
				image: $0.image,
				selectedImage: $0.selectedImage
			)

			return viewController
		}
	}
}
