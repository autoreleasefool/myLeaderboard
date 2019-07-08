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
	let viewController: UIViewController
	let image: UIImage
	let selectedImage: UIImage

}

class RootTabBarController: UITabBarController {
	private let tabItems: [TabItem] = [
		TabItem(
			title: "Games",
			viewController: GameListViewController(),
			image: UIImage(named: "Tabs/Games")!,
			selectedImage: UIImage(named: "Tabs/Games-selected")!
		),
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		self.viewControllers = createTabBarItems()
	}

	private func createTabBarItems() -> [UIViewController] {
		return tabItems.map {
			$0.viewController.tabBarItem = UITabBarItem(
				title: $0.title,
				image: $0.image,
				selectedImage: $0.selectedImage
			)

			return $0.viewController
		}
	}
}
