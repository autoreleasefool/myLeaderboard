//
//  CreateGameViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-09.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit

enum CreateGameAction {
	case nameUpdated(String)
	case hasScoresUpdated(Bool)
	case gameCreated(NewGame)
	case graphQLError(GraphAPIError)
	case userErrors
}

enum CreateGameViewAction {
	case initialize
	case updateName(String)
	case updateHasScores(Bool)
	case submit(UIViewController)
}

class CreateGameViewModel {
	typealias CreateGameMutation = MyLeaderboardApi.CreateGameMutation
	typealias ActionHandler = (_ action: CreateGameAction) -> Void

	var handleAction: ActionHandler

	private(set) var gameName: String = "" {
		didSet {
			handleAction(.nameUpdated(gameName))
		}
	}

	private var trimmedGameName: String {
		return gameName.trimmingCharacters(in: .whitespaces)
	}

	private(set) var hasScores: Bool = false {
		didSet {
			handleAction(.hasScoresUpdated(hasScores))
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

	var gameIsValid: Bool {
		return trimmedGameName.count > 0
	}

	init(handleAction: @escaping ActionHandler) {
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: CreateGameViewAction) {
		guard !isLoading else { return }

		switch viewAction {
		case .initialize: break
		case .updateName(let name):
			self.gameName = name
			updateErrors(for: CreateGameBuilder.Keys.createGameSection.rawValue)
		case .updateHasScores(let hasScores):
			self.hasScores = hasScores
		case .submit(let context):
			submit(with: context)
		}
	}

	private func updateErrors(for key: String) {
		if errors.isEmpty == false && errors[key]?.isEmpty == false {
			self.errors = findErrors()
		}
	}

	private func findErrors() -> KeyedErrors {
		var errors = KeyedErrors()

		if gameIsValid == false {
			if trimmedGameName.count == 0 {
				errors[
					CreateGameBuilder.Keys.createGameSection.rawValue,
					CreateGameBuilder.Keys.Create.error.rawValue
				] = "Name must contain at least 1 character."
			}
		}

		return errors
	}

	private func submit(with controller: UIViewController) {
		let alert = UIAlertController(
			title: "Create game?",
			message: "Are you sure you want to create a game with the name '\(trimmedGameName)'",
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "Create", style: .default) { [weak self] _ in
			self?.createGame()
		})
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		controller.present(alert, animated: true)
	}

	private func createGame() {
		let updatedErrors = findErrors()
		guard updatedErrors.isEmpty else {
			self.errors = updatedErrors
			return
		}

		isLoading = true

		CreateGameMutation(name: trimmedGameName, hasScores: hasScores).perform { [weak self] in
			self?.isLoading = false
			switch $0 {
			case .success(let response):
				if let newGame = response.createGame?.asNewGameFragmentFragment {
					self?.handleAction(.gameCreated(newGame))
				} else {
					self?.handleAction(.graphQLError(.invalidResponse))
				}
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			}
		}
	}
}
