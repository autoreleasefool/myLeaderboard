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
	case selectPlayers([PlayerListItem])
	case editGame
	case selectGame(GameListItem?)
	case selectWinner(GraphID, Bool)
	case setPlayerScore(GraphID, Int)
	case submit
}

class RecordPlayViewModel: ViewModel {
	typealias ActionHandler = (_ action: RecordPlayAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var selectedGame: GameListItem? = nil {
		didSet {
			handleAction(.playUpdated)
		}
	}

	private(set) var selectedPlayers: [PlayerListItem] = [] {
		didSet {
			winners = winners.filter { selectedPlayerGraphIDs.contains($0) }
		}
	}

	@available(*, deprecated, message: "Use selectedPlayerGraphIDs instead")
	var selectedPlayerIDs: Set<ID> { return Set(selectedPlayers.map { Int($0.id.rawValue)! }) }
	var selectedPlayerGraphIDs: Set<GraphID> { return Set(selectedPlayers.map { $0.graphID })}

	private(set) var winners: [GraphID] = [] {
		didSet {
			handleAction(.playUpdated)
		}
	}

	@available(*, deprecated, message: "Use selectedPlayerGraphIDs instead")
	var winnerIDs: Set<ID> { return Set(winners.map { Int($0.rawValue)! }) }
	var winnerGraphIDs: Set<GraphID> { return Set(winners.map { $0 })}

	private(set) var scores: [GraphID: Int] = [:] {
		didSet {
			handleAction(.playUpdated)
		}
	}

	private(set) var errors: KeyedErrors = KeyedErrors() {
		didSet {
			handleAction(.userErrors)
		}
	}

	private var isLoading: Bool = false {
		didSet {
			if isLoading {
				LoadingHUD.shared.show()
			} else {
				LoadingHUD.shared.hide()
			}
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

		if let preferredPlayer = Player.preferred {
			self.selectedPlayers = [PlayerListItem(from: preferredPlayer)]
		}
	}

	func postViewAction(_ viewAction: RecordPlayViewAction) {
		guard !isLoading else { return }

		switch viewAction {
		case .initialize:
			break
		case .selectGame(let game):
			selectedGame = game
			updateErrors(for: RecordPlayBuilder.Keys.gameSection.rawValue)
		case .selectPlayers(let players):
			selectedPlayers = players
			updateErrors(for: RecordPlayBuilder.Keys.playerSection.rawValue)
		case .selectWinner(let playerID, let selected):
			if selected {
				winners.append(playerID)
			} else {
				winners.removeAll { $0 == playerID }
			}

			updateErrors(for: RecordPlayBuilder.Keys.playerSection.rawValue)
		case .setPlayerScore(let playerID, let score):
			scores[playerID] = score
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
				errors[
					RecordPlayBuilder.Keys.gameSection.rawValue,
					RecordPlayBuilder.Keys.Game.error.rawValue
				] = "You must choose a game."
			}

			if selectedPlayers.count < 2 {
				errors[
					RecordPlayBuilder.Keys.playerSection.rawValue,
					RecordPlayBuilder.Keys.Players.error.rawValue
				] = "You must select at least 2 players."
			} else if winners.isEmpty || selectedPlayerIDs.isDisjoint(with: winnerIDs) {
				errors[
					RecordPlayBuilder.Keys.playerSection.rawValue,
					RecordPlayBuilder.Keys.Players.error.rawValue
				] = "You must select a winner."
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

		isLoading = true

		var finalScores: [Int] = []

		for player in self.selectedPlayers {
			if let playerScore = scores[player.id] {
				finalScores.append(playerScore)
			} else {
				break
			}
		}

		api.record(
			gameID: Int(game.id.rawValue)!,
			playerIDs: self.selectedPlayers.map { Int($0.id.rawValue)! },
			winnerIDs: self.winners.map { Int($0.rawValue)! },
			scores: finalScores.isEmpty ? nil : finalScores
		) { [weak self] result in
			self?.isLoading = false

			switch result {
			case .success(let play):
				self?.handleAction(.playCreated(play))
			case .failure(let error):
				self?.handleAction(.apiError(error))
			}
		}
	}
}
