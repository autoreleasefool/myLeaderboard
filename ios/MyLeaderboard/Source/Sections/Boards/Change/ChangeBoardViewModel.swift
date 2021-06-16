//
//  ChangeBoardViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-04-08.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import myLeaderboardApi

enum ChangeBoardAction: BaseAction {
	case updatedData
	case openBoard(BoardDetailsFragment)
	case graphQLError(MyLeaderboardAPIError)
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

	private var cancellables: Set<AnyCancellable> = []

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

		MLApi.shared.fetch(query: CreateBoardMutation(boardName: name))
			.sink(receiveCompletion: { [weak self] result in
				if case let .failure(error) = result {
					self?.handleAction(.graphQLError(error))
				}
				self?.isLoading = false
			}, receiveValue: { [weak self] value in
				if let board = value.createBoard?.asBoardDetailsFragmentFragment {
					self?.handleAction(.openBoard(board))
				} else {
					self?.handleAction(.error("Failed to create board"))
				}
			})
			.store(in: &cancellables)
	}

	private func joinBoard(withName name: String) {
		isLoading = true

		MLApi.shared.fetch(query: FindBoardQuery(boardName: name))
			.sink(receiveCompletion: { [weak self] result in
				if case let .failure(error) = result {
					self?.handleAction(.graphQLError(error))
				}
				self?.isLoading = false
			}, receiveValue: { [weak self] value in
				if let board = value.findBoardByName?.asBoardDetailsFragmentFragment {
					self?.handleAction(.openBoard(board))
				} else {
					self?.handleAction(.error("'\(name)'not found"))
				}
			})
			.store(in: &cancellables)
	}

	private func findBoard(withName name: String) {
		MLApi.shared.fetch(query: FindBoardQuery(boardName: name))
			.sink(receiveCompletion: { [weak self] _ in
				guard self?.boardName == name else { return }

				self?.boardState = .undetermined
				self?.handleAction(.updatedData)
			}, receiveValue: { [weak self] value in
				guard self?.boardName == name else { return }

				if value.findBoardByName?.asBoardDetailsFragmentFragment != nil {
					self?.boardState = .isJoinable
				} else {
					self?.boardState = .isCreatable
				}
			})
			.store(in: &cancellables)
	}
}
