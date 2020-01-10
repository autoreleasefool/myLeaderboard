//
//  LoadingHUD.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-12.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

class LoadingHUD {
	static let shared = LoadingHUD()

	private let window: UIWindow
	private let loadingView = UIActivityIndicatorView(style: .whiteLarge)

	private init() {
		window = UIWindow(frame: UIScreen.main.bounds)

		let controller = UIViewController()
		controller.view.isUserInteractionEnabled = false

		window.rootViewController = controller
		window.windowLevel = .alert + 1
		window.accessibilityViewIsModal = true

		setupViews(in: controller)
	}

	private func setupViews(in controller: UIViewController) {
		let backgroundView = UIView()
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.backgroundColor = UIColor.primaryExtraDark.withAlphaComponent(0.5)

		loadingView.translatesAutoresizingMaskIntoConstraints = false

		controller.view.addSubview(backgroundView)
		controller.view.addSubview(loadingView)

		NSLayoutConstraint.activate([
			backgroundView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
			backgroundView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
			backgroundView.topAnchor.constraint(equalTo: controller.view.topAnchor),
			backgroundView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),

			loadingView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
			loadingView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
			])
	}

	func show() {
		loadingView.startAnimating()
		window.makeKeyAndVisible()
	}

	func hide() {
		window.isHidden = true
		loadingView.stopAnimating()
	}
}
