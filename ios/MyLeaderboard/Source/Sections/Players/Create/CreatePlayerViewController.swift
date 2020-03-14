//
//  CreatePlayerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import Loaf

class CreatePlayerViewController: FTDViewController {
	private var api: LeaderboardAPI
	private var viewModel: CreatePlayerViewModel!

	private var playerCreated: ((Player) -> Void)?

	init(api: LeaderboardAPI, onSuccess: ((Player) -> Void)? = nil) {
		self.api = api
		self.playerCreated = onSuccess
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = CreatePlayerViewModel(api: api) { [weak self] action in
			switch action {
			case .playerUpdated, .userErrors:
				self?.render()
			case .playerCreated(let player):
				self?.playerCreated?(player)
				self?.dismiss(animated: true)
			case .apiError(let error):
				self?.presentError(error)
			}
		}

		self.title = "Create Player"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(cancel)
		)
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(submit)
		)

		render()
	}

	private func render() {
		let sections = CreatePlayerBuilder.sections(
			displayName: viewModel.displayName,
			username: viewModel.username,
			avatarURL: viewModel.avatarURL,
			errors: viewModel.errors,
			actionable: self
		)
		tableData.renderAndDiff(sections)
		updateDoneButton()
	}

	private func updateDoneButton() {
		self.navigationItem.rightBarButtonItem?.isEnabled = viewModel.playerIsValid
	}

	@objc private func cancel() {
		dismiss(animated: true)
	}

	@objc private func submit() {
		viewModel.postViewAction(.submit(self))
	}

	private func presentError(_ error: LeaderboardAPIError) {
		let message: String
		if let errorDescription = error.errorDescription {
			message = errorDescription
		} else {
			message = "Unknown error."
		}

		Loaf(message, state: .error, sender: self).show()
	}
}

extension CreatePlayerViewController: CreatePlayerActionable {
	func updatedPlayerName(name: String) {
		viewModel.postViewAction(.updateName(name))
	}

	func updatedPlayerUsername(username: String) {
		viewModel.postViewAction(.updateUsername(username))
	}
}
