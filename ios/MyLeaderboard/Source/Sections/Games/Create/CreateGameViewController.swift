//
//  CreateGameViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-09.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit
import Loaf

class CreateGameViewController: FTDViewController {
	private var viewModel: CreateGameViewModel!

	private var gameCreated: ((NewGame) -> Void)?

	init(onSuccess: ((NewGame) -> Void)? = nil) {
		self.gameCreated = onSuccess
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = CreateGameViewModel { [weak self] action in
			switch action {
			case .nameUpdated, .hasScoresUpdated:
				self?.updateDoneButton()
			case .gameCreated(let game):
				self?.gameCreated?(game)
				self?.dismiss(animated: true)
			case .graphQLError(let error):
				self?.presentError(error)
			case .userErrors:
				self?.render()
			}
		}

		self.title = "Create Game"
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
		let sections = CreateGameBuilder.sections(
			gameName: viewModel.gameName,
			hasScores: viewModel.hasScores,
			errors: viewModel.errors,
			actionable: self
		)
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

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}
}

extension CreateGameViewController: CreateGameActionable {
	func updatedGameName(name: String) {
		viewModel.postViewAction(.updateName(name))
	}

	func updatedHasScores(hasScores: Bool) {
		viewModel.postViewAction(.updateHasScores(hasScores))
	}
}
