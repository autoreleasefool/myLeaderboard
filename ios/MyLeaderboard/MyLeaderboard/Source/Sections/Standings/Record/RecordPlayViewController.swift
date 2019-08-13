//
//  RecordPlayViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-31.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

class RecordPlayViewController: FTDViewController {
	private var api: LeaderboardAPI
	private var viewModel: RecordPlayViewModel!

	init(api: LeaderboardAPI) {
		self.api = api
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = RecordPlayViewModel(api: api) { [weak self] action in
			switch action {
			case .playUpdated, .userErrors:
				self?.render()
			case .apiError(let error):
				self?.presentError(error)
			case .playCreated:
				self?.dismiss(animated: true)
			case .openGamePicker:
				self?.presentGamePicker()
			case .openPlayerPicker:
				self?.presentPlayerPicker()
			}
		}

		self.title = "Record"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submit))

		render()
		viewModel.postViewAction(.initialize)
	}

	private func render() {
		let sections = RecordPlayBuilder.sections(game: viewModel.selectedGame, players: viewModel.selectedPlayers, winners: viewModel.winnerIDs, scores: viewModel.scores, errors: viewModel.errors, actionable: self)
		tableData.renderAndDiff(sections)
	}

	@objc private func cancel() {
		dismiss(animated: true)
	}

	@objc private func submit() {
		viewModel.postViewAction(.submit)
	}

	private func presentGamePicker() {
		let initiallySelected: Set<ID>
		if let currentGame = viewModel.selectedGame {
			initiallySelected = [currentGame.id]
		} else {
			initiallySelected = []
		}

		let gamePicker = GamePickerViewController(api: api, multiSelect: false, initiallySelected: initiallySelected) { [weak self] selectedGames in
			self?.viewModel.postViewAction(.selectGame(selectedGames.first))
		}
		presentModal(gamePicker)
	}

	private func presentPlayerPicker() {
		let playerPicker = PlayerPickerViewController(api: api, initiallySelected: viewModel.selectedPlayerIDs) { [weak self] selectedPlayers in
			self?.viewModel.postViewAction(.selectPlayers(selectedPlayers))
		}
		presentModal(playerPicker)
	}

	private func presentError(_ error: Error) {
		print("Error recording play: \(error)")
	}
}

extension RecordPlayViewController: RecordPlayActionable {
	func openPlayerPicker() {
		viewModel.postViewAction(.editPlayers)
	}

	func openGamePicker() {
		viewModel.postViewAction(.editGame)
	}

	func selectWinner(_ player: Player, selected: Bool) {
		viewModel.postViewAction(.selectWinner(player, selected))
	}

	func selectGame(_ game: Game) {
		viewModel.postViewAction(.selectGame(game))
	}

	func setScore(for player: Player, score: Int) {
		viewModel.postViewAction(.setPlayerScore(player, score))
	}
}
