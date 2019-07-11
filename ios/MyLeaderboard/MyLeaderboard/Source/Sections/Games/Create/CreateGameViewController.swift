//
//  CreateGameViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-09.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

class CreateGameViewController: FTDViewController {
	private var api: LeaderboardAPI
	private var viewModel: CreateGameViewModel!

	init(api: LeaderboardAPI) {
		self.api = api
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = CreateGameViewModel(api: api) { [weak self] action in
			switch action {
			case .nameUpdated(_):
				self?.updateDoneButton()
			case .gameCreated(_):
				self?.dismiss(animated: true)
			case .error(let error):
				self?.presentError(error)
			}
		}

		self.title = "Create Game"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submit))

		render()
	}

	private func render() {
		let sections = CreateGameBuilder.sections(gameName: viewModel.gameName, actionable: self)
		tableData.renderAndDiff(sections)
		updateDoneButton()
	}

	private func updateDoneButton() {
		self.navigationItem.rightBarButtonItem?.isEnabled = viewModel.gameName.isEmpty == false
	}

	@objc private func cancel() {
		dismiss(animated: true)
	}

	@objc private func submit() {
		viewModel.postViewAction(.submit)
	}

	private func presentError(_ error: Error) {
		print("Error creating game: \(error)")
	}
}

extension CreateGameViewController: CreateGameActionable {
	func updatedGameName(name: String) {
		viewModel.postViewAction(.updateName(name))
	}
}
