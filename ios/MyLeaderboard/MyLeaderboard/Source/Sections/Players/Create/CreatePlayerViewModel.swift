//
//  CreatePlayerViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

enum CreatePlayerAction {
	case playerUpdated
	case playerCreated(Player)
	case apiError(LeaderboardAPIError)
	case userErrors
}

enum CreatePlayerViewAction {
	case initialize
	case updateName(String)
	case updateUsername(String)
	case submit(UIViewController)
}

class CreatePlayerViewModel {
	typealias ActionHandler = (_ action: CreatePlayerAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var displayName: String = "" {
		didSet {
			handleAction(.playerUpdated)
		}
	}

	private var trimmedDisplayName: String {
		return displayName.trimmingCharacters(in: .whitespaces)
	}

	private(set) var username: String = "" {
		didSet {
			handleAction(.playerUpdated)
		}
	}

	private var trimmedUsername: String {
		return username.trimmingCharacters(in: .whitespaces)
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

	var playerIsValid: Bool {
		return trimmedDisplayName.count > 0 && trimmedUsername.count > 0
	}

	init(api: LeaderboardAPI, handleAction: @escaping ActionHandler) {
		self.api = api
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: CreatePlayerViewAction) {
		guard !isLoading else { return }

		switch viewAction {
		case .initialize: break
		case .updateName(let name):
			displayName = name
		case .updateUsername(let name):
			username = name
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

		if playerIsValid == false {
			if trimmedDisplayName.count == 0 {
				errors[CreatePlayerBuilder.Keys.createPlayerSection.rawValue, CreatePlayerBuilder.Keys.Create.error.rawValue] = "Name must contain at least 1 character."
			} else if trimmedUsername.count == 0 {
				errors[CreatePlayerBuilder.Keys.createPlayerSection.rawValue, CreatePlayerBuilder.Keys.Create.error.rawValue] = "Username must contain at least 1 character."
			}
		}

		return errors
	}

	private func submit(with controller: UIViewController) {
		let alert = UIAlertController(title: "Add player?", message: "Are you sure you want to add '\(trimmedDisplayName)' as a new player?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
			self?.createPlayer()
		})
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		controller.present(alert, animated: true)
	}

	private func createPlayer() {
		let updatedErrors = findErrors()
		guard updatedErrors.isEmpty else {
			self.errors = updatedErrors
			return
		}

		isLoading = true

		api.createPlayer(name: trimmedDisplayName, username: trimmedUsername) { [weak self] result in
			self?.isLoading = false

			switch result {
			case .success(let player):
				self?.handleAction(.playerCreated(player))
			case .failure(let error):
				self?.handleAction(.apiError(error))
			}
		}
	}
}
