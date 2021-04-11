//
//  RecordPlayViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-31.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit
import Loaf

class RecordPlayViewController: FTDViewController {
	private var viewModel: RecordPlayViewModel!

	var onSuccess: ((NewPlay?) -> Void)?

	init(boardId: GraphID, onSuccess: ((NewPlay?) -> Void)? = nil) {
		self.onSuccess = onSuccess
		super.init()

		viewModel = RecordPlayViewModel(boardId: boardId) { [weak self] action in
			switch action {
			case .dataChanged, .userErrors:
				self?.render()
			case .graphQLError(let error):
				self?.presentError(error)
			case .playCreated(let play):
				self?.onSuccess?(play)
				#if !APPCLIP
				self?.dismiss(animated: true)
				#endif
			case .openGamePicker:
				self?.presentGamePicker()
			case .openPlayerPicker:
				self?.presentPlayerPicker()
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Record"

		#if !APPCLIP
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(cancel)
		)
		#endif

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(submit)
		)

		render()
		viewModel.postViewAction(.initialize)
	}

	private func render() {
		let sections = RecordPlayBuilder.sections(
			game: viewModel.selectedGame,
			players: viewModel.selectedPlayers,
			winners: viewModel.winnerGraphIDs,
			scores: viewModel.scores,
			errors: viewModel.errors,
			actionable: self
		)

		tableData.renderAndDiff(sections)
	}

	@objc private func cancel() {
		dismiss(animated: true)
	}

	@objc private func submit() {
		viewModel.postViewAction(.submit)
	}

	private func presentGamePicker() {
		let initiallySelected: Set<GraphID>
		if let currentGame = viewModel.selectedGame {
			initiallySelected = [currentGame.graphID]
		} else {
			initiallySelected = []
		}

		let gamePicker = GamePickerViewController(
			multiSelect: false,
			initiallySelected: initiallySelected
		) { [weak self] selectedGames in
			self?.viewModel.postViewAction(.selectGame(selectedGames.first))
		}
		presentModal(gamePicker)
	}

	private func presentPlayerPicker() {
		let playerPicker = PlayerPickerViewController(
			boardId: viewModel.boardId,
			initiallySelected: viewModel.selectedPlayerGraphIDs
		) { [weak self] selectedPlayers in
			self?.viewModel.postViewAction(.selectPlayers(selectedPlayers))
		}
		presentModal(playerPicker)
	}

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}
}

extension RecordPlayViewController: RecordPlayActionable {
	func openPlayerPicker() {
		viewModel.postViewAction(.editPlayers)
	}

	func openGamePicker() {
		viewModel.postViewAction(.editGame)
	}

	func selectWinner(_ playerID: GraphID, selected: Bool) {
		viewModel.postViewAction(.selectWinner(playerID, selected))
	}

	func selectGame(_ game: GameListItem) {
		viewModel.postViewAction(.selectGame(game))
	}

	func setScore(for playerID: GraphID, score: Int) {
		viewModel.postViewAction(.setPlayerScore(playerID, score))
	}
}

extension RecordPlayViewController {
	func selectGame(withId gameId: GraphID) {
		viewModel.postViewAction(.selectGameByID(gameId))
	}
}
