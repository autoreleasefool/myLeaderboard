//
//  CreateGameViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-09.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

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
			case .gameCreated(_):
				self?.dismiss(animated: true)
			case .error(let error):
				self?.presentError(error)
			}
		}
	}

	private func render() {
		let sections = CreateGameBuilder.sections(gameName: viewModel.gameName, actionable: self)
		return tableData.renderAndDiff(sections)
	}

	private func presentError(_ error: Error) {
		print("Error creating game: \(error)")
	}
}

extension CreateGameViewController: CreateGameActionable {
	func updatedGameName(name: String) {
		viewModel.postViewAction(.updateName(name))
	}

	func submitGame() {
		viewModel.postViewAction(.submit)
	}
}
