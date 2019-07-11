//
//  UIViewController+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

extension UIViewController {
	func presentModal(_ controller: UIViewController) {
		let modalController: UIViewController
		if controller is UINavigationController {
			modalController = controller
		} else {
			modalController = UINavigationController(rootViewController: controller)
		}

		present(modalController, animated: true)
	}
}
