//
//  ChangeBoardBaseViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-04-09.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import UIKit

class ChangeBoardBaseViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Board Selection"
		render()

		let changeBoardController = ChangeBoardViewController { board in
			guard let board = board else { fatalError("Board was not selected") }
			DispatchQueue.main.async {
				self.dismiss(animated: true)
				if let delegate = UIApplication.shared.delegate as? AppDelegate {
					delegate.window?.rootViewController = RootTabBarController(boardId: board.graphID)
				}
			}
		}
		changeBoardController.isModalInPresentation = true
		let controller = UINavigationController(rootViewController: changeBoardController)

		DispatchQueue.main.async {
			self.present(controller, animated: true)
		}
	}

	private func render() {
		self.view.backgroundColor = .primary

		let label = UILabel()
		label.text = "You need to select or create a board to interact with before proceeding."
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textAlignment = .center
		view.addSubview(label)
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.Spacing.standard),
			label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.Spacing.standard),
			label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}
}
