//
//  CreatePlayerViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-13.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Combine
import myLeaderboardApi
import UIKit

enum CreatePlayerAction {
	case playerUpdated
	case playerCreated(NewPlayer)
	case graphQLError(MyLeaderboardAPIError)
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
	private let debouncer = Debouncer(debounceTime: 0.4)

	private var cancellable: AnyCancellable?

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

	private(set) var isValidatingUsername: Bool = false {
		didSet {
			updateErrors()
		}
	}

	private(set) var isUsernameValid: Bool = false {
		didSet {
			updateErrors()
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
		return trimmedDisplayName.count > 0 && trimmedUsername.count > 0 && isUsernameValid
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
			updateErrors()
		case .updateUsername(let name):
			username = name
			isUsernameValid = false
			updateErrors()

			debounceValidateUsername(name: name)
		case .submit(let context):
			submit(with: context)
		}
	}

	private func updateErrors() {
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

			if isValidatingUsername {
				errors[
					CreatePlayerBuilder.Keys.previewSection.rawValue,
					CreatePlayerBuilder.Keys.Preview.error.rawValue
				] = "Finding '\(trimmedUsername)'..."
			} else if !isUsernameValid {
				errors[
					CreatePlayerBuilder.Keys.previewSection.rawValue,
					CreatePlayerBuilder.Keys.Preview.error.rawValue
				] = "The account '\(trimmedUsername)' could not be found."
			}
		}

		return errors
	}

	private func debounceValidateUsername(name: String) {
		debouncer.debounce { [weak self] in
			self?.validateUsername(name: name)
		}
	}

	private func validateUsername(name: String) {
		isValidatingUsername = true
		if let url = avatarURL {
			imageLoader.fetch(url: url) { [weak self] result in
				guard let self = self else { return }

				// If the board name was updated after the query started, discard the results
				guard self.username == name else { return }

				switch result {
				case .success(let received):
					if received.0 == self.avatarURL {
						self.isUsernameValid = true
						self.isValidatingUsername = false
					}
				case .failure(let error):
					switch error {
					case .invalidData(let url),
						.invalidHTTPResponse(let url, _),
						.invalidResponse(let url),
						.networkingError(let url, _):
						if url == self.avatarURL {
							self.isUsernameValid = false
						}
						self.isValidatingUsername = false
					case .invalidURL: break
					}
				}

				self.updateErrors()
			}
		} else {
			isValidatingUsername = false
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

		let mutation = CreatePlayerMutation(
			displayName: trimmedDisplayName,
			username: trimmedUsername,
			board: boardId
		)

		cancellable = MLApi.shared.fetch(query: mutation)
			.sink(receiveCompletion: { [weak self] result in
				if case let .failure(error) = result, let graphError = error.graphQLError {
					self?.handleAction(.graphQLError(graphError))
				}

				self?.isLoading = false
			}, receiveValue: { [weak self] value in
				if let newPlayer = value.response?.createPlayer?.asNewPlayerFragmentFragment {
					self?.handleAction(.playerCreated(newPlayer))
				} else {
					self?.handleAction(.graphQLError(.invalidResponse))
				}
			})
	}
}
