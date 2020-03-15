//
//  RecordPlayViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-31.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum RecordPlayAction: BaseAction {
	case dataChanged
	case graphQLError(GraphAPIError)
	case userErrors
	case playCreated(NewPlay)
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
	typealias RecordPlayMutation = MyLeaderboardAPI.RecordPlayMutation
	typealias ActionHandler = (_ action: RecordPlayAction) -> Void

	var handleAction: ActionHandler

	private(set) var selectedGame: GameListItem? = nil {
		didSet {
			handleAction(.dataChanged)
		}
	}

	var selectedPlayerGraphIDs: Set<GraphID> { return Set(selectedPlayers.map { $0.id })}
	private(set) var selectedPlayers: [PlayerListItem] = [] {
		didSet {
			winners = winners.filter { selectedPlayerGraphIDs.contains($0) }
		}
	}

	var winnerGraphIDs: Set<GraphID> { return Set(winners.map { $0 })}
	private(set) var winners: [GraphID] = [] {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var scores: [GraphID: Int] = [:] {
		didSet {
			handleAction(.dataChanged)
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
			selectedPlayerGraphIDs.isDisjoint(with: winnerGraphIDs) == false
	}

	init(handleAction: @escaping ActionHandler) {
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
			} else if winners.isEmpty || selectedPlayerGraphIDs.isDisjoint(with: winnerGraphIDs) {
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

		RecordPlayMutation(
			players: self.selectedPlayers.map { $0.id },
			winners: self.winners,
			game: game.id,
			scores: finalScores.isEmpty ? nil : finalScores
		).perform { [weak self] in
			self?.isLoading = false
			switch $0 {
			case .success(let response):
				if let newPlay = response.recordPlay?.asNewPlayFragmentFragment {
					self?.handleAction(.playCreated(newPlay))
				} else {
					self?.handleAction(.graphQLError(.invalidResponse))
				}
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			}
		}
	}
}
