//
//  ChangeBoardViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-04-08.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

enum ChangeBoardAction: BaseAction {
	case updatedData
	case openBoard(BoardDetailsFragment)
	case graphQLError(GraphAPIError)
	case error(String)
}

enum ChangeBoardViewAction: BaseViewAction {
	case updateBoardName(String)
	case createBoard(String)
	case joinBoard(String)
	case findBoard(String)
	case selectPublicBoard
}

class ChangeBoardViewModel: ViewModel {
	typealias FindBoardQuery = MyLeaderboardApi.BoardDetailsByNameQuery
	typealias CreateBoardMutation = MyLeaderboardApi.CreateBoardMutation

	typealias ActionHandler = (_ action: ChangeBoardAction) -> Void

	var handleAction: ActionHandler

	private(set) var boardName: String = {
		// Allows initial name to be set for testing
		ProcessInfo.processInfo.environment["initialBoardName"] ?? ""
	}()
	private(set) var boardState: BoardState = .undetermined

	private var isLoading: Bool = false {
		didSet {
			if isLoading {
				LoadingHUD.shared.show()
			} else {
				LoadingHUD.shared.hide()
			}
		}
	}

	init(handleAction: @escaping ActionHandler) {
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: ChangeBoardViewAction) {
		guard !isLoading else { return }
		switch viewAction {
		case .updateBoardName(let name):
			boardName = name
			boardState = .undetermined
			handleAction(.updatedData)
		case .selectPublicBoard:
			joinBoard(withName: "Public")
		case .findBoard(let name):
			findBoard(withName: name)
		case .joinBoard(let name):
			joinBoard(withName: name)
		case .createBoard(let name):
			createBoard(withName: name)
		}
	}

	private func createBoard(withName name: String) {
		isLoading = true

		CreateBoardMutation(boardName: name).perform { [weak self] in
			self?.isLoading = false
			switch $0 {
			case .success(let response):
				if let board = response.createBoard?.asBoardDetailsFragmentFragment {
					self?.handleAction(.openBoard(board))
				} else {
					self?.handleAction(.error("Failed to create board"))
				}
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			}
		}
	}

	private func joinBoard(withName name: String) {
		isLoading = true

		FindBoardQuery(boardName: name).perform { [weak self] in
			self?.isLoading = false
			switch $0 {
			case .success(let response):
				if let board = response.findBoardByName?.asBoardDetailsFragmentFragment {
					self?.handleAction(.openBoard(board))
				} else {
					self?.handleAction(.error("'\(name)'not found"))
				}
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			}
		}
	}

	private func findBoard(withName name: String) {
		FindBoardQuery(boardName: boardName).perform { [weak self] in
			guard let self = self else { return }

			// If the board name was updated after the query started, discard the results
			guard self.boardName == name else { return }

			switch $0 {
			case .success(let response):
				if response.findBoardByName?.asBoardDetailsFragmentFragment != nil {
					self.boardState = .isJoinable
				} else {
					self.boardState = .isCreatable
				}
			case .failure:
				self.boardState = .undetermined
			}

			self.handleAction(.updatedData)
		}
	}
}
