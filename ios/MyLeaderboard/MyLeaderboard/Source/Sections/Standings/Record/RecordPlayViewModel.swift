//
//  RecordPlayViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-31.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum RecordPlayAction: BaseAction {
	case playUpdated
	case apiError(LeaderboardAPIError)
	case userErrors
	case playCreated(GamePlay)
	case openPlayerPicker
	case openGamePicker
}

enum RecordPlayViewAction: BaseViewAction {
	case initialize
	case editPlayers
	case selectPlayers([Player])
	case editGame
	case selectGame(Game?)
	case selectWinner(Player, Bool)
	case setPlayerScore(Player, Int)
	case submit
}

class RecordPlayViewModel: ViewModel {
	typealias ActionHandler = (_ action: RecordPlayAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var selectedGame: Game? = nil {
		didSet {
			handleAction(.playUpdated)
		}
	}

	private(set) var selectedPlayers: [Player] = [] {
		didSet {
			winners = winners.filter { selectedPlayers.contains($0) }
		}
	}

	var selectedPlayerIDs: Set<ID> { return Set(selectedPlayers.map { $0.id }) }

	private(set) var winners: [Player] = [] {
		didSet {
			handleAction(.playUpdated)
		}
	}

	var winnerIDs: Set<ID> { return Set(winners.map { $0.id }) }

	private(set) var scores: [ID: Int] = [:] {
		didSet {
			handleAction(.playUpdated)
		}
	}

	private(set) var errors: KeyedErrors = KeyedErrors() {
		didSet {
			handleAction(.userErrors)
		}
	}

	var playIsValid: Bool {
		return selectedGame != nil &&
			selectedPlayers.count > 1 &&
			winners.isEmpty == false &&
			selectedPlayerIDs.isDisjoint(with: winnerIDs) == false
	}

	init(api: LeaderboardAPI, handleAction: @escaping ActionHandler) {
		self.api = api
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: RecordPlayViewAction) {
		switch viewAction {
		case .initialize:
			break
		case .selectGame(let game):
			selectedGame = game
			updateErrors(for: RecordPlayBuilder.Keys.gameSection.rawValue)
		case .selectPlayers(let players):
			selectedPlayers = players
			updateErrors(for: RecordPlayBuilder.Keys.playerSection.rawValue)
		case .selectWinner(let player, let selected):
			if selected {
				winners.append(player)
			} else {
				winners.removeAll { $0.id == player.id }
			}

			updateErrors(for: RecordPlayBuilder.Keys.playerSection.rawValue)
		case .setPlayerScore(let player, let score):
			scores[player.id] = score
		case .editGame:
			handleAction(.openGamePicker)
		case .editPlayers:
			handleAction(.openPlayerPicker)
		case .submit:
			createPlay()
		}
	}

	private func updateErrors(for key: String) {
		if errors.isEmpty == false && errors[key]?.isEmpty == false {
			self.errors = findErrors()
		}
	}

	private func findErrors() -> KeyedErrors {
		var errors = KeyedErrors()

		if playIsValid == false {
			if selectedGame == nil {
				errors[RecordPlayBuilder.Keys.gameSection.rawValue, RecordPlayBuilder.Keys.Game.error.rawValue] = "You must choose a game."
			}

			if selectedPlayers.count < 2 {
				errors[RecordPlayBuilder.Keys.playerSection.rawValue, RecordPlayBuilder.Keys.Players.error.rawValue] = "You must select at least 2 players."
			} else if winners.isEmpty || selectedPlayerIDs.isDisjoint(with: winnerIDs) {
				errors[RecordPlayBuilder.Keys.playerSection.rawValue, RecordPlayBuilder.Keys.Players.error.rawValue] = "You must select a winner."
			}
		}

		return errors
	}

	private func createPlay() {
		let updatedErrors = findErrors()
		guard let game = selectedGame, updatedErrors.isEmpty else {
			self.errors = updatedErrors
			return
		}

		let selectedPlayers = self.selectedPlayers.map { $0.id }
		let winners = self.winners.map { $0.id }
		var finalScores: [Int] = []

		for player in selectedPlayers {
			if let playerScore = scores[player] {
				finalScores.append(playerScore)
			} else {
				break
			}
		}

		api.record(
			gameID: game.id,
			playerIDs: selectedPlayers,
			winnerIDs: winners,
			scores: finalScores.isEmpty ? nil : finalScores
		) { [weak self] result in
			switch result {
			case .success(let play):
				self?.handleAction(.playCreated(play))
			case .failure(let error):
				self?.handleAction(.apiError(error))
			}
		}
	}
}
