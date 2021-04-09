//
//  CreatePlayerViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import MyLeaderboardApi
import UIKit

enum CreatePlayerAction {
	case playerUpdated
	case playerCreated(NewPlayer)
	case graphQLError(GraphAPIError)
	case userErrors
}

enum CreatePlayerViewAction {
	case initialize
	case updateName(String)
	case updateUsername(String)
	case submit(UIViewController)
}

class CreatePlayerViewModel {
	typealias CreatePlayerMutation = MyLeaderboardApi.CreatePlayerMutation
	typealias ActionHandler = (_ action: CreatePlayerAction) -> Void

	let boardId: GraphID
	var handleAction: ActionHandler
	var imageLoader = ImageLoader(queryIfCached: true)

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

	var avatarURL: URL? {
		guard trimmedUsername.count > 0 else { return nil }
		return URL(string: "https://github.com/\(trimmedUsername).png")
	}

	private(set) var validatingUsername: Bool = false {
		didSet {
			updateErrors(for: CreatePlayerBuilder.Keys.previewSection.rawValue)
		}
	}

	private(set) var usernameValid: Bool = false {
		didSet {
			updateErrors(for: CreatePlayerBuilder.Keys.previewSection.rawValue)
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

	var playerIsValid: Bool {
		return trimmedDisplayName.count > 0 && trimmedUsername.count > 0 && usernameValid
	}

	init(boardId: GraphID, handleAction: @escaping ActionHandler) {
		self.boardId = boardId
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: CreatePlayerViewAction) {
		guard !isLoading else { return }

		switch viewAction {
		case .initialize: break
		case .updateName(let name):
			displayName = name
			updateErrors(for: CreatePlayerBuilder.Keys.createPlayerSection.rawValue)
		case .updateUsername(let name):
			username = name
			updateErrors(for: CreatePlayerBuilder.Keys.createPlayerSection.rawValue)
			validateUsername()
		case .submit(let context):
			submit(with: context)
		}
	}

	private func updateErrors(for key: String) {
		self.errors = findErrors()
	}

	private func findErrors() -> KeyedErrors {
		var errors = KeyedErrors()

		if !playerIsValid {
			if trimmedDisplayName.count == 0 {
				errors[
					CreatePlayerBuilder.Keys.createPlayerSection.rawValue,
					CreatePlayerBuilder.Keys.Create.error.rawValue
				] = "Name must contain at least 1 character."
			} else if trimmedUsername.count == 0 {
				errors[
					CreatePlayerBuilder.Keys.createPlayerSection.rawValue,
					CreatePlayerBuilder.Keys.Create.error.rawValue
				] = "Username must contain at least 1 character."
			}

			if validatingUsername {
				errors[
					CreatePlayerBuilder.Keys.previewSection.rawValue,
					CreatePlayerBuilder.Keys.Preview.error.rawValue
				] = "Finding '\(trimmedUsername)'..."
			} else if !usernameValid {
				errors[
					CreatePlayerBuilder.Keys.previewSection.rawValue,
					CreatePlayerBuilder.Keys.Preview.error.rawValue
				] = "The account '\(trimmedUsername)' could not be found."
			}
		}

		return errors
	}

	private func validateUsername() {
		usernameValid = false
		validatingUsername = true
		if let url = avatarURL {
			imageLoader.fetch(url: url) { [weak self] result in
				switch result {
				case .success(let received):
					if received.0 == self?.avatarURL {
						self?.usernameValid = true
						self?.validatingUsername = false
					}
				case .failure(let error):
					switch error {
					case .invalidData(let url),
						.invalidHTTPResponse(let url, _),
						.invalidResponse(let url),
						.networkingError(let url, _):
						if url == self?.avatarURL {
							self?.usernameValid = false
						}
						self?.validatingUsername = false
					case .invalidURL: break
					}
				}
			}
		} else {
			validatingUsername = false
		}
	}

	private func submit(with controller: UIViewController) {
		let alert = UIAlertController(
			title: "Add player?",
			message: "Are you sure you want to add '\(trimmedDisplayName)' as a new player?",
			preferredStyle: .alert
		)
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

		CreatePlayerMutation(
			displayName: trimmedDisplayName,
			username: trimmedUsername,
			board: boardId
		).perform { [weak self] in
			self?.isLoading = false
			switch $0 {
			case .success(let response):
				if let newPlayer = response.createPlayer?.asNewPlayerFragmentFragment {
					self?.handleAction(.playerCreated(newPlayer))
				} else {
					self?.handleAction(.graphQLError(.invalidResponse))
				}
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			}
		}
	}
}
