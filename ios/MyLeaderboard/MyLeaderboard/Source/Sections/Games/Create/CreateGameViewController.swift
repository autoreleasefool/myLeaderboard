//
//  CreateGameViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-09.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import Loaf

class CreateGameViewController: FTDViewController {
	private var api: LeaderboardAPI
	private var viewModel: CreateGameViewModel!

	private var gameCreated: ((Game) -> Void)?

	init(api: LeaderboardAPI, onSuccess: ((Game) -> Void)? = nil) {
		self.api = api
		self.gameCreated = onSuccess
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = CreateGameViewModel(api: api) { [weak self] action in
			switch action {
			case .nameUpdated:
				self?.updateDoneButton()
			case .gameCreated(let game):
				self?.gameCreated?(game)
				self?.dismiss(animated: true)
			case .apiError(let error):
				self?.presentError(error)
			case .userErrors:
				self?.render()
			}
		}

		self.title = "Create Game"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submit))

		render()
	}

	private func render() {
		let sections = CreateGameBuilder.sections(gameName: viewModel.gameName, errors: viewModel.errors, actionable: self)
		tableData.renderAndDiff(sections)
		updateDoneButton()
	}

	private func updateDoneButton() {
		self.navigationItem.rightBarButtonItem?.isEnabled = viewModel.gameIsValid
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

extension CreateGameViewController: CreateGameActionable {
	func updatedGameName(name: String) {
		viewModel.postViewAction(.updateName(name))
	}
}
